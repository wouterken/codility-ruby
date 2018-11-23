def solution(p)
  total_nodes  = count_nodes(p.length)
  falses = 0
  false_length = 0
  p.each do |val|
    if val
      falses += count_nodes(false_length)
      false_length = 0
    else
      false_length += 1
    end
  end
  falses += count_nodes(false_length)
  [1_000_000_000, total_nodes - falses].min
end

def count_nodes(length)
  ((length / 2.0 + 0.5) * length).to_i
end

def assert_correct(got, expected)
  if (got == expected)
    puts 'match'
  else
    puts "Expected #{expected} got #{got}"
  end
end

assert_correct(solution([true, false, false, true, false]), 11)
assert_correct(solution([true, false, false, true]), 7)
# assert_correct(solution([0, 3, 5, 1, 6],[4, 1, 3, 3, 8],"pXpqp"), 2)
# assert_correct(solution([0, 6, 2, 5, 3, 0],[4, 8, 2, 3, 1, 6],"ppqpXp"), 12)

