# frozen_string_literal: true

class Trie
  class Node
    attr_reader :children, :value

    def initialize
      @children = Hash.new
      @value = nil
    end

    def value=(val)
      @value = val
    end
  end

  def initialize(dictionary)
    @root = Node.new
    dictionary.each do |word|
      insert(word)
    end
  end

  def insert(word)
    node = @root
    word.each_char do |ch|
      if !node.children[ch]
        node.children[ch] = Node.new
      end
      node = node.children[ch]
    end
    node.value = word
  end

  def find?(word)
    node = traverse(word)
    !node.nil? && node.value == word
  end

  def find_suggestions(prefix)
    node = traverse(prefix)
    return [] unless node

    recursive_find_suggestions(prefix, node, [])
  end

  private

  def traverse(prefix)
    node = @root
    prefix.each_char do |char|
      node = node.children[char]
      break if node.nil?
    end

    node
  end

  def recursive_find_suggestions(prefix, node, result)
    result << node.value if node.value

    node.children.values.each do |child|
      recursive_find_suggestions(prefix, child, result)
    end

    result
  end
end
