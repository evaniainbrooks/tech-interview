# frozen_string_literal: true

require 'ostruct'

class CSV
  DEFAULT_DELIMITER = ","
  DEFAULT_QUOTE_CHAR = "\""

  attr_reader :delimiter, :quote_char, :body

  class Scanner
    attr_reader :body, :delimiter, :quote_char, :escape_char

    TOKEN_EOF = 0
    TOKEN_NEWLINE = 1
    TOKEN_DELIMITER = 2
    TOKEN_EMPTY_STRING = ""

    def initialize(body, delimiter, quote_char)
      @body = body
      @delimiter = delimiter
      @quote_char = quote_char
      @escape_char = "'"
      @pos = 0
    end

    def next_token
      delimiter_or_newline_or_eof_or_column
    end

    private

    def delimiter_or_newline_or_eof_or_column
      if peek(delimiter)
        TOKEN_EMPTY_STRING
      else
        newline_or_eof_or_column
      end
    end

    def newline_or_eof_or_column
      if @pos >= body.length
        TOKEN_EOF
      elsif peek("\n")
        TOKEN_NEWLINE
      else
        quoted_or_unquoted_column
      end
    end

    def quoted_or_unquoted_column
      if peek(quote_char)
        quoted_column.tap do
          expect(quote_char)
          peek(delimiter)
        end
      else
        unquoted_column.tap do
          peek(delimiter)
        end
      end
    end

    def peek(expected)
      result = body[@pos, expected.length]
      return false unless result == expected

      @pos = @pos + expected.length
      result
    end

    def expect(expected)
      peek(expected) || raise("Expected '#{ch}' at #{@pos + i} got '#{body[@pos + i]}'")
    end

    def quoted_column
      result = String.new
      escaped = false

      start = @pos
      while @pos < body.length
        # Handle different escaping styles, either '<delim>' or <delim><delim>
        if !escaped && body[@pos] == escape_char
          escaped = true
        elsif escaped && (body[@pos] == escape_char || body[@pos] != quote_char)
          escaped = false
        elsif !escaped && body[@pos] == quote_char && body[@pos + 1] != quote_char
          break
        end

        @pos = @pos + 1
      end

      # Messy :/ gsub to replace escaped double delim
      body[start..(@pos - 1)].gsub("#{quote_char}#{quote_char}", quote_char)
    end

    def unquoted_column
      start = @pos
      while @pos < body.length && body[@pos] != delimiter && body[@pos] != "\n"
        @pos = @pos + 1
      end

      body[start..(@pos - 1)]
    end
  end

  def self.parse(body, delimiter = DEFAULT_DELIMITER, quote_char = DEFAULT_QUOTE_CHAR)
    new(body, delimiter, quote_char).parse!
  end

  def initialize(body, delimiter, quote_char)
    @body = body
    @delimiter = delimiter
    @quote_char = quote_char
    @scanner = Scanner.new(body, delimiter, quote_char)
  end

  def parse!
    token = @scanner.next_token

    row = []
    result = []
    while token != Scanner::TOKEN_EOF
      if token == Scanner::TOKEN_NEWLINE
        row = [""] if row == []
        result << row
        row = []
      else
        row << token
      end

      token = @scanner.next_token
    end

    result << row
    result
  end
end
