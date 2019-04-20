
DENOMINATIONS = [1,3,4,10,26].freeze

def make_change(amount, r = Hash.new { |h, k| h[k] = [] })
  if r[:min].length > 1 && r[:min].length < r[:curr].length
    return
  end
  if amount == 0 && (r[:curr].length < r[:min].length || r[:min].length == 0)
    r[:min] = r[:curr].dup
    return
  end

  DENOMINATIONS.reverse.map do |coin|
    r[:curr] << coin
    make_change(amount - coin, r) if amount - coin >= 0
    r[:curr].pop
  end

  r[:min]
end

(0..200).each { |i|
  print i
  print ": "
  puts make_change(i).inspect
}
