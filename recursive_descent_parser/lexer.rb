# frozen_string_literal: true

# Turn a character stream into a stream of tokens
class Lexer
  class Symbol
    EOF = 0
    NL = 1
    NUMERIC = 2
    PLUS = '+'
    MINUS = '-'
    DIVIDE = '/'
    MULTIPLY = '*'
    ASSIGN = '='
    IDENT = 7
    LITERAL = 8
    RPAREN = ')'
    LPAREN = '('

    attr_reader :type, :data

    def initialize(type, data)
      @type = type
      @data = data
    end

    def ==(o)
      if o.is_a?(Symbol)
        type == o.type && data == o.data
      else
        type == o
      end
    end
  end

  def initialize(body)
    @body = body
    @pos = 0
  end

  def next_token
    consume_ws
    # TODO: Why do we need to strip?
    if eof?
      Symbol.new(Symbol::EOF, nil)
    elsif numeric?
      Symbol.new(Symbol::NUMERIC, consume_num)
    elsif literal?
      Symbol.new(Symbol::LITERAL, consume_lit)
    elsif ident?
      Symbol.new(Symbol::IDENT, consume_ident)
    else
      result = consume_op
      Symbol.new(result[0], result.strip)
    end
  end

  def all_tokens(include_eof: false)
    tok = next_token
    result = []
    while tok.type != Lexer::Symbol::EOF
      result << tok
      tok = next_token
    end

    result << tok
    result
  end

  def reset!
    @pos = 0
  end

  private

  def consume_lit
    consume_until(@body[@pos], include_delim: true)
  end

  def consume_ident
    start = @pos
    while !eof? && (numeric? || ident?)
      @pos = @pos + 1
    end

    @body[start..(@pos - 1)]
  end

  def consume_num
    start = @pos
    while !eof? && numeric?
      @pos = @pos + 1
    end

    @body[start..(@pos - 1)]
  end

  def consume_op
    start = @pos
    while !eof? && !peek?(' ') && !ident? && !numeric?
      @pos = @pos + 1
    end

    @body[start..(@pos - 1)]
  end

  def consume_ws
    while !eof? && peek?(' ')
      @pos = @pos + 1
    end
  end

  def eof?
    @pos >= @body.length
  end

  def ident?
    peek_between?('a', 'z') || peek?('_')
  end

  def numeric?
    peek_between?('0', '9')
  end

  def literal?
    peek?("'") || peek?('"')
  end

  def peek?(ch)
    @body[@pos] == ch
  end

  def peek_between?(ch0, ch1)
    @body[@pos].ord >= ch0.ord && @body[@pos].ord <= ch1.ord
  end

  def consume_until(delim, include_delim: false)
    start = @pos
    @pos = @pos + 1
    while !eof? && @body[@pos] != delim
      @pos = @pos + 1
    end

    @pos = @pos + 1 if include_delim
    start = start + 1 unless include_delim
    @body[start..@pos]
  end
end
