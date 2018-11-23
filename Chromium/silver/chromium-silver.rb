require 'pry-byebug'

def solution(nodes)
  indices_by_height = nodes.each.with_index.sort_by(&:first).to_h
  count = 0

  paths_left  = Hash.new(0)
  paths_right = Hash.new(0)

  positions = []

  indices_by_height.each do |height, midpoint|

    lefts = 0
    rights = 0

    # Optimise here. We shouldn't need this loop.
    # We should be able to do this in a single step, tell how many paths we can complete
    # and update some intermediate structure so that all paths which include
    # this node are counted
    positions.each do |p|
      if p < midpoint
        paths = paths_left[p]
        paths_right[p] += paths
        lefts += paths
      elsif p > midpoint
        paths = paths_right[p]
        paths_left[p] += paths
        rights += paths
      end
    end

    #
    # Every step we increase by the total step size
    # Every step the total step size increases by 1 + (number of completed trains)
    # Every new step creates N new trains
    # And closes N other trains

    positions << midpoint
    paths_right[midpoint] += 1
    paths_left[midpoint]  += 1
    count += lefts + rights + 1

  end

  count % 1_000_000_007
end
