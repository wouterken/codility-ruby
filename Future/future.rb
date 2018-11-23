def solution(a,b)
  total = b.inject(:+)
  return -1 if a.inject(:+) != total
  return (sweep_right(*a.zip(b).map{|va, vb| minus_min(va,vb) }.transpose) % (10e8 + 7)).to_i
end

def minus_min(a,b)
  min = [a,b].min
  [a-min, b-min]
end

def sweep_right(a,b, reverse=true)
  total = to_reserve = 0
  carry = [0,0]
  a.zip(b).each.with_index do |(start_state, end_state), i|
    next_carry = [0,0]
    reserved_count = [to_reserve, start_state].min
    available  = start_state - reserved_count
    to_reserve -= reserved_count
    delta      = available - end_state
    if delta >= 0
      excess = delta
      shuffle, shifted = carry
      shuffle += excess
      next_carry = [shifted, shuffle]
      total += shuffle
      a[i] = reserved_count
      b[i] = 0
    else
      shortfall = delta.abs
      next_carry[1], shortfall = minus_min(carry[0], shortfall)
      next_carry[0], shortfall = minus_min(carry[1], shortfall)
      total += next_carry[1]
      to_reserve += shortfall
      used = delta.abs - shortfall
      b[i] = end_state - used
    end
    carry = next_carry
  end
  total += sweep_right(a.reverse, b.reverse, false) if reverse
  return total
end


def assert_correct(got, expected)
  if (got == expected)
    puts 'match'
  else
    puts "Expected #{expected} got #{got}"
  end
end


assert_correct(
  solution([0, 0, 2, 1, 8, 8, 2, 0],[8, 5, 2, 4, 0, 0, 0, 2]), 31
)
