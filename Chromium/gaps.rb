require 'pry-byebug'
require_relative 'chromium'
class Array
  def bs_idx(position)
    low = 0; high = length - 1
    until low > high
      mid = low + ((high - low) / 2)
      case self[mid][:from] <=> position
      when  1 then high = mid - 1
      when -1 then low = mid + 1
      when  0 then return mid
      end
    end
    return low
  end
end

def solution(values)
  values = values.each_with_index.sort_by(&:first).map.with_index do |(_, position), height|
    [height + 1, position]
  end
  tree = [{from: 0, to: values.length - 1, lpaths: 0, rpaths: 0, height: Float::INFINITY}]
  total = step = 0

  values.reverse_each do |height, position|
    # binding.pry if position == 2
    insert_at = tree.bs_idx(position)
    insert_at -= 1 if tree[insert_at].nil? || tree[insert_at][:from] > position
    gap = tree[insert_at]
    puts tree.inspect
    step  = 1 + gap[:lpaths] + gap[:rpaths]
    gather_rpaths = ->(idx){
      paths  = 1
      min = Float::INFINITY
      tree[idx..-1].each do |node|
        if node[:height] < min
          min = node[:height]
          paths += node[:rpaths]
        end
      end
      return paths
    }
    gather_lpaths = ->(idx){
      paths  = 1
      min = Float::INFINITY
      tree[0...idx].reverse_each do |node|
        if node[:height] < min
          min = node[:height]
          paths += node[:lpaths]
        end
      end
      return paths
    }
    rpaths = gather_rpaths[insert_at]
    lpaths = gather_lpaths[insert_at]
    left  = {from: gap[:from],   to: position - 1, lpaths: gap[:lpaths], rpaths: lpaths + gap[:rpaths], height: height}
    right = {from: position + 1, to: gap[:to], rpaths: gap[:rpaths], lpaths: rpaths + gap[:lpaths], height: height}

    to_insert = []
    to_insert << left if left[:from] < left[:to]
    to_insert << right if right[:from] < right[:to]
    tree[insert_at..insert_at] = to_insert if to_insert.any?
    puts "Paths at #{height} = #{step}"
    total += step
  end
  puts tree.inspect
  total
end


values = [3,1,2]
puts solution2(values)
puts solution(values)

# values = [3,1,2]
# puts solution2(values)
# puts solution(values)

# values = [3,4,1,2]
# puts solution2(values)
# puts solution(values)