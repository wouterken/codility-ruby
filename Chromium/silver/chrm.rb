require 'pry-byebug'
require 'ostruct'
RIGHT = -1
LEFT = 1

def solution(values)

  print "["
  print (values.length.times.map do |i|
    "#{values[i]}".rjust(2)
  end * ", ")
  puts "] "

  values = values.each.with_index.sort_by(&:first).map.with_index(1) do |(_, position), height|
    [height, position]
  end.to_h

  indices = values.invert


  step = 0
  total = 1

  left_neighbors  = Array.new(values.length)
  right_neighbors = Array.new(values.length)
  left_paths      = Array.new(values.length)
  right_paths     = Array.new(values.length)

  previous = values.first.last
  left_neighbor  = nil
  right_neighbor = nil
  values.each do |height, position|
    change = 0
    case direction = previous <=> position
    when  0 then
    when  RIGHT then
      right_paths[previous] = right_paths[previous].to_i + 1
      right_paths[position] = right_paths[previous].to_i + left_paths[previous].to_i
      left_neighbor = left_neighbors[position] = previous
      right_neighbor = right_neighbors[previous]
      while right_neighbor && right_neighbor < position
        right_neighbor = right_neighbors[right_neighbor]
      end
      right_neighbors[position] = right_neighbor
    when LEFT then
      left_paths[previous] = left_paths[previous].to_i + 1
      left_paths[position] = left_paths[previous].to_i + right_paths[previous].to_i
      right_neighbor = right_neighbors[position] = previous
      left_neighbor  = left_neighbors[previous]
      while left_neighbor && left_neighbor > position
        left_neighbor = left_neighbors[left_neighbor]
      end
      left_neighbors[position] = left_neighbor
    end

    previous = position

    puts "@#{height}, LN#{indices[left_neighbor]} RN#{indices[right_neighbor]} LP#{left_paths[position]} RP#{right_paths[position]}"
    change = 1 +
    step  += change
    total += step
  end
  puts "#{left_paths}"
  puts "#{right_paths}"
  total % 1_000_000_007
end

values = [7,8,6,3,2,4,1,5,9]
puts solution(values)


   1
     2
        3
4
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