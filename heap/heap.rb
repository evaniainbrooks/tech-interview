# frozen_string_literal: true

class Heap
  def initialize(max_size: 100)
    @data = []
  end

  def <<(val)
    @data << val
    bubble_up(@data.size - 1)
  end

  def pop
    return nil unless @data.size

    swap(0, @data.size - 1)
    result = @data.pop
    bubble_down(0)
    result
  end

  private

  def bubble_down(index)
    right_index = (index + 1) * 2
    left_index = right_index - 1

    return if left_index >= @data.size

    last_elem = right_index >= @data.size
    if !last_elem && @data[right_index] > @data[left_index]
      return if @data[index] >= @data[right_index]
      swap(index, right_index)
      bubble_down(right_index)
    else
      return if @data[index] >= @data[left_index]
      swap(index, left_index)
      bubble_down(left_index)
    end
  end

  def bubble_up(index)
    parent_index = (index - 1) / 2
    return if index == 0
    return if @data[index] <= @data[parent_index]

    swap(index, parent_index)

    bubble_up(parent_index)
  end

  def swap(x, y)
    tmp = @data[x]
    @data[x] = @data[y]
    @data[y] = tmp
  end
end

h = Heap.new
h << 100
h << 200
h << 300
h << 50
h << 25
h << 12
h << 500
h << 1000

while (v = h.pop)
  puts v
end
puts 'done'
