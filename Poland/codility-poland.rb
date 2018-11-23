# you can use puts for debugging purposes, e.g.
# puts "this is a debug message"

def solution(a)
    sea_slices = find_slices(a.map(&:zero?))
    mountain_slices = find_slices(a.map(&:nonzero?), true)
    best = 0
    (a.length - 1).times do |i|
      if sea_slices[i] && mountain_slices[i + 1]
        best = [best, sea_slices[i] + mountain_slices[i + 1]].max
      end
    end
    best
end

def find_slices(a, reversed=false)
  a.reverse! if reversed
  rev_ind = a.length - 1
  prefix_hash = {}
  total = 0
  best = {}
  a.each.with_index do |b, i|
    direction = (b ? 1 : -1)
    total += direction
    unless prefix_hash[total]
      prefix_hash[total] = i
    end
    slice_cutoff = -(1 - total)

    if total > 0
      best[reversed ? rev_ind - i : i ] = i + 1
    elsif prefix_hash[slice_cutoff]
      best[reversed ? rev_ind - i : i] = i - prefix_hash[slice_cutoff]
    end
  end
  best
end