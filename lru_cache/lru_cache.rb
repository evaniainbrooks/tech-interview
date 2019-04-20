# frozen_string_literal: true

require_relative './linked_list'

class LRUCache
  DEFAULT_MAX_SIZE = 100

  def initialize(max_size: DEFAULT_MAX_SIZE)
    @max_size = max_size
    reset!
  end

  def reset!
    @data = {}
    @tail = @head = LinkedList.new(data: nil)
  end

  def fetch(key, &block)
    puts "size is #{@data.size}"
    if @data.key?(key)
      touch_key(key)
      evict_lru

      return @data[key].data[:value]
    end

    raise "cache miss" unless block_given?
    result = yield
    store_data(key, result)
    evict_lru
    result
  end

  private

  def touch_key(key)
    node = @data[key].unlink!
    @tail.append(node.data)
  end

  def evict_lru
    if @data.size > @max_size
      node = @head.nextp.unlink!
      @data.delete(node.data[:key])
    end
  end

  def store_data(key, data)
    node = @tail.append({ key: key, value: data })
    @data[key] = node
    @tail = node
  end
end

x  = LRUCache.new(max_size: 3)
x.fetch('a') do
  puts 'a'
  100
end

x.fetch('b') do
  puts 'b'
  200
end

x.fetch('c') do
  puts 'c'
  300
end

x.fetch('d') do
  puts 'd'
  300
end

x.fetch('e') do
  puts 'e'
  300
end

x.fetch('b') do
  puts 'b'
  300
end

x.fetch('e') do
  puts 'e'
  300
end

x.fetch('a')
