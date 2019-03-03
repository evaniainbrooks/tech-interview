# frozen_string_literal: true

class AstPrintVisitor
  def initialize(root)
    @root = root
  end

  def traverse!
    visit_node(@root)
  end

  private

  def visit_node(node, depth: 0)
    print ' ' * depth
    data = node.respond_to?(:symbol) ? node.symbol : node.data
    puts "<#{node.class}: #{data}>"

    visit_node(node.left, depth: depth + 1) if node.respond_to?(:left)
    visit_node(node.right, depth: depth + 1) if node.respond_to?(:right)
  end
end

class AstEvaluateVisitor
  def initialize(root)
    @root = root
  end

  def traverse!
    ident = @root.left.data
    result = visit_node(@root.right)

    puts "#{ident} = #{result}"
  end

  private

  def visit_node(node)
    if (node.symbol == Lexer::Symbol::PLUS)
      return term(node.left) + term(node.right)
    elsif (node.symbol == Lexer::Symbol::MINUS)
      return term(node.left) - term(node.right)
    elsif (node.symbol == Lexer::Symbol::MULTIPLY)
      return term(node.left) * term(node.right)
    elsif (node.symbol == Lexer::Symbol::DIVIDE)
      return term(node.left) / term(node.right)
    end
  end

  def term(node)
    if node.respond_to?(:symbol)
      visit_node(node)
    else
      node.data.to_i
    end
  end
end
