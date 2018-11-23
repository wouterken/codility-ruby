require 'pry-byebug'
# require_relative 'tree'
require 'ostruct'

def solution2(nodes)
  indices_by_height = nodes.each.with_index.sort_by(&:first).to_h
  # left_trails, right_trails = Tree.build_counts(nodes)
  count = 0

  paths_left  = Hash.new(0)
  paths_right = Hash.new(0)

  positions = []
  prev = 0

  print "["
  print (nodes.length.times.map do |i|
    "#{nodes[i]}".rjust(2)
  end * ", ")
  puts "] "

  counter_cache = OpenStruct.new({
    left: Array.new(nodes.length),
    right: Array.new(nodes.length)
  })

  step_size = 0
  test_total = 0
  indices_by_height.each do |height, position|

    total = 1
    lefts = 0
    rights = 0
    # direction = height == 1 ? nil : (indices_by_height[height - 1] < position ?  :right : :left)

    # Optimise here. We shouldn't need this loop.
    # We should be able to do this in a single step, tell how many paths we can complete
    # and update some intermediate structure so that all paths which include
    # this node are counted
    # prev_left = paths_left.dup
    # prev_right = paths_right.dup
    positions.each do |p|
      if p < position
        paths = paths_left[p]
        paths_right[p] += paths
        lefts += paths
      else
        paths = paths_right[p]
        paths_left[p] += paths
        rights += paths
      end
    end

    # puts paths_left[2].inspect
    # puts paths_right[2].inspect
    # binding.pry if height == 5
    # increment =
    # case direction
    # when :left then right_trails[position] - right_trails[indices_by_height[height - 1]]
    # when :right then left_trails[position] - left_trails[indices_by_height[height - 1]]
    # else 1
    # end

    # if height < nodes.length - 1
    #   counter_cache.left[height + 1]  = counter_cache.left[height].to_i + 1 + left_trails[indices_by_height[height]]
    #   counter_cache.right[height + 1] = counter_cache.right[height].to_i + 1 + right_trails[indices_by_height[height]]
    # end

    pinfo = ->{
        print "["
        print (nodes.length.times.map do |i|
          "#{case i
          when position then "X"
          when 0...position then paths_left[i]
          when position...nodes.length then paths_right[i]
          end}".rjust(2)
        end * ", ")
        puts "] #{height}=x(#{lefts + rights + 1}) - Change: #{(lefts + rights + 1) - prev}"
        # puts "cc L:#{counter_cache.left[height]} R:#{counter_cache.right[height]}."
    }
    # binding.pry if height >= 3
    #
    # Every step we increase by the total step size
    # Every step the total step size increases by 1 + (number of completed trains)
    # Every new step creates N new trains
    # And closes N other trains
    pinfo[]

    # step_size += increment
    # test_total += step_size

    positions << position
    paths_right[position] += 1
    paths_left[position] += 1
    prev = lefts + rights + 1
    count += lefts + rights + 1

  end

  # puts "#{left_trails}"
  # puts "#{right_trails}"
  puts  count % 1_000_000_007

  puts "Test total #{test_total}"
  count % 1_000_000_007
end


def assert_eq(l, r)
  puts l != r ? "Expected #{r} got #{l}" : "Match"
end


# solution(values = [5,3,1,2,4])

# starts = Time.now
# solution([1,11,5,8,7,10,3,9,6,4,2,44,36,27,81,95,41]) # 761
# ends = Time.now
# puts "Took #{ends - starts}"
# solution([4,2,3,5,1])
# solution([11,10,2, 1,8,7,3, 6,4,9,5])
# solution([8,4,2,7,3,5,6,1,10,9,18,13,17,14,43,11, 12])
# assert_eq solution([ 3, 5, 2, 1, 4 ]), 23
# assert_eq solution([ 3, 1, 4, 2 ]), 12
# assert_eq solution([3, 1, 2 ]), 7