require 'pry-byebug'

require_relative 'silver/chromium'

FROM, TO, PATHS, TOTAL, HEIGHT = 5.times.to_a
def solution(values)
  tree, step, total, last = [[0, 0, 1, 1, 2]], 1, 1, 0
  jumps = []
  values.each.with_index.sort_by(&:first).map.with_index(1).to_a[1..-1].each do |(_, position), height|
    print "\r#{height},#{tree.length}      "
    step += 1
    insert_at = begin
      low = 0
      high = tree.length - 1
      until low > high
        mid = low + ((high - low) / 2)
        case tree[mid][FROM] > position
        when true then high = mid - 1
        else low  = mid + 1
        end
      end
      low
    end
    calcs = []
    insert = [position, position, 1,1,height + 1]
    tree.insert(insert_at, insert)
    insert_at < last ? (idx = insert_at+1; max=last+1) : (idx=last+1; max=insert_at)
    change = 0
    while idx < max
      node         = tree[idx]
      paths        = (node[TOTAL] + (node[PATHS] * (height - node[HEIGHT]))) % 1_000_000_007
      step         = (step + paths - node[PATHS]) % 1_000_000_007
      node[HEIGHT] = height
      node[TOTAL]  = node[PATHS]
      node[PATHS]  = paths
      idx += 1
    end
    if insert_at < tree.length - 2 && tree[insert_at + 1][FROM] == insert[TO].succ
      insert[TO]     = tree[insert_at + 1][TO]
      insert[TOTAL] += tree[insert_at + 1][TOTAL] + (height - tree[insert_at + 1][HEIGHT]) * tree[insert_at + 1][PATHS]
      insert[PATHS] += tree[insert_at + 1][PATHS]
      tree.delete_at(insert_at + 1)
    end
    if insert_at > 0 && tree[insert_at - 1][TO].succ == insert[FROM]
      # insert[FROM] = tree[insert_at - 1][FROM]
      # tree.delete_at(insert_at - 1)
      # insert_at -= 1
    end
    last  = insert_at
    step  = (step + change) % 1_000_000_007
    total = (total + step) % 1_000_000_007
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
# values = [2, 1, 3]
# puts solution2(values)
starts = Time.now
values = 50_000.times.map{|i| i}.shuffle
# puts solution(values)
ends = Time.now
puts "Took #{ends - starts}"
puts solution([1, 11, 5, 8, 7, 10, 3, 9, 6, 4, 2, 15, 13, 12, 16, 17, 14])