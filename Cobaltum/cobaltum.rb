# you can write to stdout for debugging purposes, e.g.
# puts "this is a debug message"

def solution(a, b)
  prev_opts = {[- Float::INFINITY, - Float::INFINITY] => 0}
  a.each_with_index do |va, i|
    vb = b[i]
    next_opts = Hash.new(Float::INFINITY)
    prev_opts.each do |(pa, pb), swaps|
      next_opts[[va, vb]] =  [swaps,   next_opts[[va, vb]]].min if va > pa && vb > pb
      next_opts[[vb, va]] =  [swaps+1, next_opts[[vb, va]]].min if va > pb && vb > pa
    end
    return -1 if next_opts.empty?
    prev_opts = next_opts
  end
  prev_opts.values.min || -1
end


def assert_correct(got, expected)
  if (got == expected)
    puts 'match'
  else
    puts "Expected #{expected} got #{got}"
  end
end


assert_correct(solution([5,3,7,7,10], [1,6,6,9,9]),   2)
assert_correct(solution([5,-3,6,4,8], [2,6,-5,1,0]), -1)
assert_correct(solution([1,5,6], [-2,0,2]), 0)
assert_correct(solution([-1, 0, 2, 5, 9, 11, 11, 13, 13],[-1, 0, 4, 4, 5, 8, 12, 12, 14]), 3)
assert_correct(solution(
  [-30, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, -1],
  [1, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, 30],
), 2)
assert_correct(solution(
  [-13,  -12,  0, -6,  5,  9, 12 , 4, 18,  8],
  [-15,  -4, -7,  3, -5, -4,  0, 17,  7, 25]),
4)
assert_correct(solution(
  [14, 16, 16, 17, 18, 19, 21, 22],
  [14, 15, 17, 18, 19, 20, 20, 21]
), 3)


# ten_mil = 10_000_000.times.map{|i|  i }
# ten_mil2 = 10_000_000.times.map{|i| i }
# puts :start
# solution(ten_mil, ten_mil2)
# puts :end