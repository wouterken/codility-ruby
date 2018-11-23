require 'pry-byebug'

def solution(input)
  summed = input.reduce([]) do |mem, value|
    mem << mem[-1].to_i + value
  end
  min_maxes = Hash.new do |h, value|
    {min: nil, max: nil}
  end

  [best_solution(input), best_solution(input.reverse)].max
end

def best_solution(input)
  summed = input.reduce([]) do |mem, value|
    mem << mem[-1].to_i + value
  end
  min_maxes = Hash.new{|h,v| h[v] = {min: nil, max: nil}}
  max_positive = 0
  summed.each_with_index do |value, index|
    min_maxes[value][:min] ||= index
    min_maxes[value][:max] = index
    max_positive = index+1 if value >= 0
  end
  min_maxes.values.map{|mm| [max_positive, mm[:max]].max - mm[:min]}.max
end

def assert_correct(got, expected)
  if (got == expected)
    puts 'match'
  else
    puts "Expected #{expected} got #{got}"
  end
end

assert_correct(
  solution([-1, -1, -1, -1, 1, -1, 1, 0, 1, -1, -1]),
  7
)

assert_correct(
  solution([-1, -1, -1, 1, 1, -1, -1, -1, -1, -1, 1, 1]),
  4
)

assert_correct(
  solution([1,1,1,1,1]),
  5
)

assert_correct(
  solution([-1, -1, -1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 0, 0]),
  12
)

assert_correct(
  solution([0, 0, 0, 0]),
  4
)