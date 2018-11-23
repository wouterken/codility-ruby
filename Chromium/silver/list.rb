require 'pry-byebug'
require 'ostruct'

def solution(values)
  values = values.each.with_index.sort_by(&:first).map.with_index(1) do |(height, position), index|
    [index, position]
  end

  height, position = values.first
  build_node = ->(height, position){ OpenStruct.new({
    height: height,
    position: position,
    left: nil,
    right: nil,
    last_height: nil,
    paths: {
        left: 1,
        right: 1
      }
    })
  }

  switch = ->(node, direction, height){
    unless node.dir
      node.dir = direction
      node.last_height = height
      0
    else
      opposite = direction == :left ? :right : :left
      levels = height - node.last_height
      node.paths[direction] += node.paths[opposite] * levels
      node.last_height = height
      node.paths[direction] - node.paths[opposite]
    end
  }

  insert = ->(node, left, right){
    node.left  = left
    node.right = right
    left.right = node if left
    right.left = node if right
    node
  }

  node = build_node[height, position]
  step = 1
  total = 1
  values[1..-1].each do |height, position|
    change = 1
    next_node = build_node[height, position]
    direction = position > node.position ? :right : :left
    case direction
    when :left
      until node.left.nil? || node.left.position < position
        change += switch[node, direction, height]
        node = node.left
      end
      change += switch[node, direction, height]

      node = insert[next_node, node.left, node]
    when :right
      until node.right.nil? || node.right.position > position
        change += switch[node, direction, height]
        node = node.right
      end
      change += switch[node, direction, height]

      node = insert[next_node, node, node.right]
    end
    step += change
    total += step
  end
  total % 1_000_000_007
end


def find_unequal
  (9..11).each do |i|
    values = i.times.with_index(1).to_a.map(&:last)
    values.permutation.each do |values|
      return values if solution2(values) != solution(values)
    end
  end
end
# values = [2,5,1,3,4]
# puts solution(values)
# puts solution2(values)
# puts "Unequal #{find_unequal}"
# values = [4,1,3,6]
# values = 50_000.times.map{|i| i}.shuffle
# puts solution2(values)
#
# puts solution(1000.times.map{|i| i}.shuffle)
# starts = Time.now
puts solution([1,11,5,8,7,10,3,9,6,4,2,44,36,27,81,95,41])
# ends = Time.now
# puts "Took #{ends - starts}"
#