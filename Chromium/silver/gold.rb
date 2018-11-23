require 'pry-byebug'
require_relative 'chromium'
require 'ostruct'

LEFT_POSITION  = 0
RIGHT_POSITION = 1
HEIGHT         = 2
LEFT_NEIGHBOR  = 3
RIGHT_NEIGHBOR = 4
TOTAL_HEIGHT   = 5
PATHS          = 6
CURRENT        = 7

LEFT  = -1
RIGHT = 1

def solution2(values)
  by_height = values.each.with_index.sort_by(&:first).map.with_index(1) do |(_, position), height|
    [height, position]
  end.to_h

  root = node = OpenStruct.new ({
    from: by_height[1],
    to: by_height[1],
    value: 1,
    left: nil,
    right: nil,
    height: 2,
    paths: 1,
    current: 1
  })

  insert = ->(node, left, right){
    node[:left] = left
    node[:right] = right
    right[:left] = node if right
    left[:right] = node if left
  }

  left_size = ->(node){
    return 0 unless node
    return 1 + left_size[node[:left]]
  }

  right_size = ->(node){
    return 0 unless node
    return 1 + right_size[node[:right]]
  }

  tree_size = ->(node){
    return left_size[node] + 1 + right_size[node]
  }

  step = total = 1

  by_height.to_a[1..-1].each do |height, position|
    print "\r#{tree_size[node]}/#{height}"
    previous = nil
    change = 1
    direction = position <=> node[:from]
    new_node = OpenStruct.new({
      from: by_height[height],
      to: by_height[height],
      value: height,
      left: nil,
      right: nil,
      height: height + 1,
      paths: 1,
      current: 1
    })

    case direction
    when LEFT
      left_neighbor = node
      if node[:left]

        while left_neighbor[:left] && left_neighbor[:left][:to] > position
          left_neighbor = left_neighbor[:left]

          node_height, paths, current = left_neighbor[:height],left_neighbor[:paths],left_neighbor[:current]
          increase    = (paths * (height - node_height)) % 1_000_000_007
          current       = (current + increase) % 1_000_000_007
          change        = (change  + current - paths) % 1_000_000_007
          left_neighbor[:height], left_neighbor[:paths], left_neighbor[:current] = height, current, paths
          if previous && left_neighbor[:to].succ == previous[:from]
            left_neighbor[:current] = (left_neighbor[:current] + previous[:current]) % 1_000_000_007
            left_neighbor[:paths] = (left_neighbor[:paths] + previous[:paths]) % 1_000_000_007
            left_neighbor[:right] = previous[:right]
            left_neighbor[:right][:left] = left_neighbor if left_neighbor[:right]
            left_neighbor[:to] = previous[:to]
          end
          previous = left_neighbor
        end
      end
      insert[new_node, left_neighbor[:left], left_neighbor]
    when RIGHT
      right_neighbor = node
      if node[:right]
        while right_neighbor[:right] && right_neighbor[:right][:from] < position
          right_neighbor = right_neighbor[:right]

          node_height, paths, current = right_neighbor[:height],right_neighbor[:paths],right_neighbor[:current]
          increase    = (paths * (height - node_height)) % 1_000_000_007
          current     = (current + increase) % 1_000_000_007
          change      = (change + current - paths) % 1_000_000_007
          right_neighbor[:height], right_neighbor[:paths], right_neighbor[:current] = height, current, paths
          if previous && previous[:to].succ == right_neighbor[:from]
            right_neighbor[:current] = (right_neighbor[:current]  + previous[:current]) % 1_000_000_007
            right_neighbor[:paths]   = (right_neighbor[:paths]    + previous[:paths]) % 1_000_000_007
            right_neighbor[:left]     = previous[:left]
            right_neighbor[:left][:right] = right_neighbor if right_neighbor[:left]
            left_neighbor[:from] = previous[:from]
          end

          previous = right_neighbor
        end
      end

      insert[new_node, right_neighbor, right_neighbor[:right]]

    end
    # puts change
    node = new_node
    step = (step + change) % 1_000_000_007
    total = (total + step ) % 1_000_000_007
  end
  binding.pry
  total
end

def find_unequal
  (3..11).each do |i|
    values = i.times.with_index(1).to_a.map(&:last)
    values.permutation.each do |values|
      return values if solution2(values) != solution(values)
    end
  end
end

# find_unequal
values = 50_000.times.map{|i| i}.shuffle
puts solution([4,1,2,3,5])
puts solution2(values)