require 'pry-byebug'
require 'ostruct'

def solution(values)
  values = values.each.with_index.sort_by(&:first).map.with_index(1) do |(height, position), index|
    [index, position]
  end

  heights_by_position = values.to_h.invert

  paths   = Array.new(values.size)
  heights = Array.new(values.size)
  seen   = [values.first.last]

  step = 0
  last_position = 0
  total = 1
  values[1..-1].each do |height, position|
    change = 1
    found, insert_position = seen.bs_idx(position)
    last_position += 1 if insert_position <= last_position
    seen.insert(insert_position, position)
    left,right = [insert_position, last_position].sort
    puts "Counting #{right - left} values at height #{height}"
     binding.pry if height == 4
    (left..right).each do |i|
      midpoint = heights_by_position[seen[i]]
      next if midpoint == height
      last_height = heights[i] || midpoint
      levels = (height - last_height) - 1
      next if levels <= 0
      path    = paths[i]  || 1
      increase = path * levels
      puts "Increase at #{heights_by_position[seen[i]]} is #{increase}"
      paths[i] = path + increase
      change += increase
      binding.pry if midpoint == 2
      heights[i] = height
    end

    last_position = insert_position
    step += change
    total += step
  end
  total % 1_000_000_007
end


class Array
  def bs_idx(value)
    low = 0; high = length - 1
    until low > high
      mid = low + ((high - low) / 2)
      cmp = self[mid] <=> value
      if cmp == 1
        high = mid - 1
      elsif cmp == -1
        low = mid + 1
      elsif cmp == 0
        return [true, mid]
      end
    end
    return [false, low]
  end
end

def find_unequal
  (9..11).each do |i|
    values = i.times.with_index(1).to_a.map(&:last)
    values.permutation.each do |values|
      return values if solution2(values) != solution(values)
    end
  end
end
values = [4 ,2 ,1, 3, 5]
puts solution(values)
# puts solution2(values)
# puts "Unequal #{find_unequal}"
# values = [4,1,3,6]
# values = 50_000.times.map{|i| i}.shuffle
# puts solution(values)
# #
# puts solution(1000.times.map{|i| i}.shuffle)
# starts = Time.now
# puts solution([2,4,1,3])
# ends = Time.now
# puts "Took #{ends - starts}"
#