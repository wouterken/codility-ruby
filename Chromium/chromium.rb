require 'pry-byebug'

require_relative 'silver/chromium'

FROM, PATHS, TOTAL, HEIGHT = 4.times.to_a
def solution(values)
  tree, step, total, last = [[0, 1, 1, 2]], 1, 1, 0
  jumps = []
  values.each.with_index.sort_by(&:first).map.with_index(1).to_a[1..-1].each do |(_, position), height|
    print "\r#{height}"
    step += 1
    insert_at = begin
      low = 0
      high = tree.length - 1
      until low > high
        mid = low + ((high - low) / 2)
        case tree[mid][FROM] < position
        when true then high = mid - 1
        else low  = mid + 1
        end
      end
      low
    end
    calcs = []
    tree.insert(insert_at, [position,1,1,height + 1])
    insert_at < last ? (idx = insert_at+1; max=last+1) : (idx=last+1; max=insert_at)
    change = 0
    while idx < max
      node         = tree[idx]
      paths        = (node[TOTAL] + (node[PATHS] * (height - node[HEIGHT]))) % 1_000_000_007
      step         = (step + paths - node[PATHS]) % 1_000_000_007
      node[HEIGHT] = height
      node[TOTAL]  = node[PATHS]
      node[PATHS]  = paths
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
values = 50_000.times.map{|i| i}.shuffle
puts solution(values)
# puts solution([1, 11, 5, 8, 7, 10, 3, 9, 6, 4, 2, 15, 13, 12, 16, 17, 14])