# frozen_string_literal: true

class IsBinaryTreeVisitor
  def initialize(node)
    @node = node
  end

  def visit
    visit_node(@node)
  end

  def self.visit(node)
    new(node).visit
  end

  private

  def visit_node(node, max: nil, min: nil)
    return true unless node

    return false if max && node.val > max
    return false if min && node.val < min

    visit_node(node.left, max: node.val, min: min) &&
      visit_node(node.right, max: max, min: node.val)
  end
end

class BinaryTree
  attr_reader :left, :right, :val

  def initialize(left, right, val)
    @left = left
    @right = right
    @val = val
  end

  def self.root_node(val)
    new(nil, nil, val)
  end

  def valid?
    IsBinaryTreeVisitor.visit(self)
  end
end
