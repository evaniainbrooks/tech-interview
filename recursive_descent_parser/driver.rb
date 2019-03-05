# frozen_string_literal: true

require_relative './ast_visitor'
require_relative './lexer'
require_relative './parser'

def print_result(input)
  lexer = Lexer.new(input)
  lexer.reset!
  parser = Parser.new(lexer)

  parser.parse!

  result = parser.tree
  AstPrintVisitor.new(result).traverse!
  AstEvaluateVisitor.new(result).traverse!
end

print_result("a = 1 + 2 * 3")
print_result("a = 1 + 2 + (3 * 4) / 6 * 7 * (8 - 9)")
