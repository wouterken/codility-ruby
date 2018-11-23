require 'pry'
require 'pry-byebug'
def count_both_ways(input)
  count_right     = Hash.new(0)
  count_left      = Hash.new(0)
  cache = []
  input.length.times do |li|
    ri = input.length - 1 -li
    left_char  = input[li]
    right_char = input[ri]
    count_right[right_char] += 1
    count_left[left_char] += 1
    cache[li]  ||= {}
    cache[ri] ||= {}
    cache[li][:left] = count_left.dup
    cache[ri][:right] = count_right.dup
  end
  diff = ->(supr, sub){
    res = {}
    supr.each do |key, value|
      res[key] = supr[key] - sub[key]
    end
    res
  }
  valid = ->(counts){ counts.values.count(&:odd?) < 2 }
  total = 0
  size  = 1

  left = cache[0][:left]
  cache.each do |right|
    right = right[:left]
    slice = diff[right, left]

    if ! valid[slice]
      left = right
      size = 1
    else
      total += size
      size += 1
    end
  end

  size = 1
  right = cache[-1][:right]
  cache.reverse.each do |left|
    left = left[:right]
    slice = diff[left, right]

    if ! valid[slice]
      right = left
      size = 1
    else
      total += size
      size += 1
    end
  end

  total
end

puts count_both_ways('0200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020202')