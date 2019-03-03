# frozen_string_literal: true

require_relative './lexer'

#
# Lets parse simple expressions such as
# (a + (c * d) / 2 + 1.0)
#
class Parser
  AstNode = Struct.new(:left, :right, :symbol)

  attr_reader :tree

  def initialize(lexer)
    @lexer = lexer
    reset!
  end

  def parse!
    if (left = accept?(Lexer::Symbol::IDENT))
      sym = expect(Lexer::Symbol::ASSIGN)
      right = expression
      expect(Lexer::Symbol::EOF)

      @tree = AstNode.new(left, right, sym)
    else
      raise "parse failed, got #{left.inspect}"
    end
  end

  def reset!
    @pos = 0
    @tokens = @lexer.all_tokens(include_eof: true)
    @symbol_table = Hash.new
    @tree = nil
  end

  private

  def expression
    if token == Lexer::Symbol::PLUS || token == Lexer::Symbol::MINUS
      next_token
    end

    left = term
    result = left
    while token == Lexer::Symbol::PLUS || token == Lexer::Symbol::MINUS
      sym = next_token
      right = term

      result = AstNode.new(left, right, sym)
    end

    result
  end

  def term
    left = factor
    result = left
    while token == Lexer::Symbol::DIVIDE || token == Lexer::Symbol::MULTIPLY
      sym = next_token
      right = factor

      result = AstNode.new(left, right, sym)
    end

    result
  end

  def factor
    result =
      if (tok = accept?(Lexer::Symbol::IDENT))
        tok
      elsif (tok = accept?(Lexer::Symbol::NUMERIC))
        tok
      elsif (tok = accept?(Lexer::Symbol::LPAREN))
        expression.tap do
          expect(Lexer::Symbol::RPAREN)
        end
      else
        raise "parse factor failed, got #{token.inspect}"
      end

    result
  end

  def next_token
    token.tap do
      @pos = @pos + 1
    end
  end

  def token
    @tokens[@pos]
  end

  def done?
    @pos >= @tokens.length
  end

  def accept?(sym)
    if token == sym
      token.tap do
        next_token
      end
    else
      nil
    end
  end

  def expect(sym)
    accept?(sym) || raise("expected #{sym} got #{token.type}")
  end
end
