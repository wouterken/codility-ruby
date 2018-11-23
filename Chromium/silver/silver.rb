class Array
  def bs_idx(position)
    low = 0; high = length - 1
    until low > high
      mid = low + ((high - low) / 2)
      case self[mid][0] <=> position
      when  1 then high = mid - 1
      when -1 then low = mid + 1
      when  0 then return mid
      end
    end
    return low
  end
end

def solution(values)
  by_height = values.each.with_index.sort_by(&:first).map.with_index(1) do |(_, position), height|
    [height, position]
  end
  cache     = []
  to_delete = []
  last = total = step = 0
  by_height.each do |height, position|
    print "\r#{height}"
    insert_index = cache.bs_idx(position)
    # puts "Insert #{height} at #{insert_index}:#{position}"

    cache.insert(insert_index, [position, position, height, 1, 0] )
    change = 1
    if last
      if insert_index <= last
        dec = false
        min, max = insert_index, last + 1
      else
        dec = true
        min, max = last, insert_index
      end
      previous = nil

      while (min+=1) < max
        node  = cache[min]
        right = (node[4] + node[3] * (height - node[2]))% 1_000_000_007
        change += right - node[3]
        node[2] = height
        if previous && previous[1].+(1) == node[0]
          previous[4] += node[3]
          previous[3] += right
          previous[1] = node[1]
          to_delete << min
        else
          node[4] = node[3]
          node[3] = right
          previous = node
        end
      end

      unless to_delete.empty?
        from = 0
        insert_index -= to_delete.length if dec
        to_delete << cache.length
        cache = to_delete.flat_map do |to|
          slice = cache.slice(from, to - from)
          from = to + 1
          slice
        end
        to_delete.clear
      end
    end
    step = (step + change) % 1_000_000_007
    total = (total + step) % 1_000_000_007
    last = insert_index
  end
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
# puts solution([2,4, 1,3])
# starts = Time.now
# puts solution(values )
# ends = Time.now
# puts "Took #{ends - starts}"
puts solution(values)