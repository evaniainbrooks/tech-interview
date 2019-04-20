#
# 1 2 3
# 4 5 6
# 7 8 9
#   0
#
# case of 1,1 => max size of N is 2
# 1,6
# 1,8
# if r.size == n
#   return r+start
#
# r << start
# ADJACENCY_LIST[start].each do |neighbour|
#   unique_numbers(neighbour, n, r)
# end
#
#
require 'set'

ADJACENCY_LIST = {
  1 => [6,8],
  2 => [7,9],
  3 => [4,8],
  4 => [0,3,9],
  5 => [],
  6 => [0,1,7],
  7 => [2,6],
  8 => [1,3],
  9 => [2,4],
  0 => [4,6]
}.freeze

def unique_sequences(start, n, r = [], &block)
  if r.size == n
    yield [r, start].flatten
    return
  end

  r << start
  ADJACENCY_LIST[start].each do |neighbour|
    unique_sequences(neighbour, n, r, &block)
  end
  r.pop
end

def unique_dials(start, n)
  result = 0
  unique_sequences(start, n) do |sequence|
    result += 1
  end
  result
end


def unique_dials2(start, n)
  if n == 0
    return 1
  end

  ADJACENCY_LIST[start].inject(0) do |sum, neighbour|
    sum += unique_dials2(neighbour, n - 1)
    sum
  end
end

def unique_dials3(start, n, d = Hash.new { |h, k| h[k] = {} })
  if !d[start][n].nil?
    return d[start][n]
  end

  if n == 0
    return 1
  end

  result = ADJACENCY_LIST[start].inject(0) do |sum, neighbour|
    sum += unique_dials3(neighbour, n - 1, d)
    sum
  end
  d[start][n] = result
  result
end

def unique_dials4(start, n, d = {})
  if !d[[start,n]].nil?
    return d[[start,n]]
  end

  if n == 0
    return 1
  end

  result = ADJACENCY_LIST[start].inject(0) do |sum, neighbour|
    sum += unique_dials4(neighbour, n - 1, d)
    sum
  end
  d[[start,n]] = result
  result
end

require 'benchmark'

puts(Benchmark.realtime do
  puts unique_dials(1, 2)
  puts unique_dials(1, 0)
  puts unique_dials(6, 3)
  puts unique_dials(6, 10)
  puts unique_dials(6, 13)
  puts unique_dials(6, 16)
  puts unique_dials(0, 17)
end)

puts(Benchmark.realtime do
  puts unique_dials2(1, 2)
  puts unique_dials2(1, 0)
  puts unique_dials2(6, 3)
  puts unique_dials2(6, 10)
  puts unique_dials2(6, 13)
  puts unique_dials2(6, 16)
  puts unique_dials2(0, 17)
end)

puts(Benchmark.realtime do
  puts unique_dials3(1, 2)
  puts unique_dials3(1, 0)
  puts unique_dials3(6, 3)
  puts unique_dials3(6, 10)
  puts unique_dials3(6, 13)
  puts unique_dials3(6, 16)
  puts unique_dials3(0, 17)
  puts unique_dials3(0, 100)
end)

puts(Benchmark.realtime do
  puts unique_dials4(1, 2)
  puts unique_dials4(1, 0)
  puts unique_dials4(6, 3)
  puts unique_dials4(6, 10)
  puts unique_dials4(6, 13)
  puts unique_dials4(6, 16)
  puts unique_dials4(0, 17)
  puts unique_dials4(0, 100)
end)
