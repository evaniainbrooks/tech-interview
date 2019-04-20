# frozen_string_literal: true

class JSON
  def self.parse(body)
    JSON.new(body).parse
  end

  def initialize(body)
    @body = body
    @pos = 0
  end

  def parse
    parse_object_or_array
  end

  private

  OPEN_OBJECT = '{'
  CLOSE_OBJECT = '}'
  OPEN_ARRAY = '['
  CLOSE_ARRAY = ']'
  KEY_DELIM = ':'
  STRING_DELIM = '"'
  COMMA = ','

  def parse_object_or_array
    if peek?(OPEN_OBJECT)
      parse_object
    else
      parse_array
    end
  end

  def parse_object
    expect(OPEN_OBJECT)
    result = {}
    while (key = parse_key)
      expect(KEY_DELIM)
      val = parse_value
      result[key] = val
      accept(COMMA)
    end
    expect(CLOSE_OBJECT)
    result
  end

  def parse_array
    expect(OPEN_ARRAY)
    result = []
    while (val = parse_value)
      result << val
      accept(COMMA)
    end
    expect(CLOSE_ARRAY)
    result
  end

  def parse_value
    if peek?(CLOSE_ARRAY) || peek?(CLOSE_OBJECT)
      return false
    elsif peek?(STRING_DELIM)
      parse_string
    elsif numeric?
      parse_numeric
    elsif (bool = parse_boolean)
      bool == 'true' ? true : false
    else
      parse_object_or_array
    end
  end

  def parse_string
    expect(STRING_DELIM)
    result = parse_until(STRING_DELIM)
    expect(STRING_DELIM)
    result
  end

  def parse_numeric
    start = @pos
    while numeric? || peek?('.')
      @pos += 1
    end

    @body[start..(@pos-1)].to_i
  end

  def parse_boolean
    true_str = 'true'
    false_str = 'false'
    if @body[@pos..(@pos + false_str.length - 1)] == false_str
      @pos += false_str.length
      return 'false'
    elsif @body[@pos..(@pos + true_str.length - 1)] == true_str
      @pos += true_str.length
      return 'true'
    else
      return false
    end
  end

  def parse_key
    if peek?(CLOSE_OBJECT)
      return false
    elsif peek?(STRING_DELIM)
      parse_until(KEY_DELIM)[1..-2]
    else
      parse_until(KEY_DELIM)
    end
  end

  def parse_until(delim)
    start = @pos
    while !peek?(delim) && !eof?
      @pos += 1
    end

    @body[start..(@pos-1)]
  end

  def eof?
    @pos >= @body.length
  end

  def peek?(ch)
    @pos += 1 while (@body[@pos] == ' ' || @body[@pos] == '\n') && !eof?
    @body[@pos] == ch
  end

  def numeric?
    @body[@pos].ord >= '0'.ord && @body[@pos].ord <= '9'.ord
  end

  def accept(ch)
    @pos += 1 if peek?(ch)
  end

  def expect(ch)
    raise "Expected #{ch}" unless accept(ch)
  end
end
