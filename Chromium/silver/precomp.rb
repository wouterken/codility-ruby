require 'set'
require 'matrix'

class Array
  def bs_idx
    low = 0; high = length - 1
    until low > high
      mid = low + ((high - low) / 2)
      cmp = yield(self[mid])
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


def count_stack(switches, height=switches.first, max=switches.last)
  return (max + 1 - height) unless switches.any?
  switches = [height] + switches
  left  = 1
  right = 1
  total = 1
  path = 0
  last_height = height

  # branch = $tree
  # switches.each do |switch|
  #   branch = branch[switch - switches[0]]
  # end
  switches.each do |level|
    levels = level - last_height
    next if levels.zero?
    if path == 1
      increase = left * levels
      path = 0
      total = (total + (increase)) % 1_000_000_007
      right = (right + increase)% 1_000_000_007
    else
      increase = right * levels
      path = 1
      total = (total +(increase)) % 1_000_000_007
      left  = (left +increase) % 1_000_000_007
    end
    last_height = level
  end
  levels = max - switches[-1]
  total += ((path == 1 ? left : right) * levels) % 1_000_000_007
  return total
end

def solution2(values)
  puts "Start"
  indices_by_height = values.each.with_index.sort_by(&:first).map.with_index(1) do |(height, position), index|
    [index, position]
  end.to_h

  heights_by_index = indices_by_height.invert
  puts "Initial sort"
  switches = Array.new(values.size)
  removes = Array.new(values.size)

  position = indices_by_height[1]

  indices_by_height.to_a[1..-1].each do |height, next_position|
    direction = next_position < position ? :left : :right
    case direction
    when :left
      # binding.pry
      switches[next_position] ||= Set.new
      switches[next_position] << height - 1
      removes[position] ||= Set.new
      removes[position] << height - 1
    when :right
      switches[position] ||= Set.new
      switches[position] << height - 1
      removes[next_position] ||= Set.new
      removes[next_position] << height - 1
    end
    position = next_position
  end

  puts "Build switches"
  current_switches = []

  switches.each.with_index.reduce(0) do |total, (node_switches, position)|
    print "\r#{position}"
    height = heights_by_index[position]

    to_remove = removes[position]
    change_index = nil
    (to_remove || []).each do |remove|
      found, remove_index = current_switches.bs_idx{|x| x <=> remove}
      if found
        current_switches.delete_at(remove_index)
      end
    end

    if node_switches
      node_switches.each do |switch|
        _, insert_index = current_switches.bs_idx{|x| x <=> switch }
        current_switches.insert(insert_index, switch)
      end
    end

    found, insert_index = current_switches.bs_idx{|x| x <=> height }
    applicable = current_switches[(found ? (insert_index + 1): insert_index)..-1]

    # matrix = (applicable + [values.length]).each_cons(4).map{|l1, r1, l2, r2| get_matrix([r1 - l1, r2 - l1])}.inject(:*)
    # matrix = get_matrix(pairs)
    # binding.pry
    # puts "S#{height}: #{count_stack(height, applicable, values.length)}"
    step = count_stack(applicable, height, values.length) % 1_000_000_007
    # puts "Step #{step}"
    # print "\r#{position}: #{step}"
    (total + step) % 1_000_000_007
  end
end

def find_unequal
  (3..9).each do |i|
    values = i.times.with_index(1).to_a.map(&:last)
    values.permutation.each do |values|
      return values if solution2(values) != solution(values)
    end
  end
end
# values = [2,1,3,4]
# puts solution(values)
# puts solution2(values)
# puts "Unequal #{find_unequal}"
# values = [4,1,3,6]
#

values = 50_000.times.map{|i| i}.shuffle
# starts = Time.now
# puts solution2(values)
# ends = Time.now
# puts "Took #{ends - starts}"
starts = Time.now
puts solution2(values)
ends = Time.now
puts "Took #{ends - starts}"