require 'pry'
require 'pry-byebug'

def solution(a)
  odd_indices    = a.each.with_index.select{|x| x.first.odd? }.map(&:last)
  # print (a.map{|i| i.even? ? 2 : 1}*"") +"\n"
  return "0,#{a.length - 1}" if a.inject(:+).even?
  return "NO SOLUTION"       if a.length == 1
  solutions = []
  solutions << [0, a.length - 2] if odd_indices[-1] == a.length - 1
  solutions << [1, a.length - 1] if odd_indices[0] == 0
  solutions << shrink_biggest_half(a, odd_indices[0]) if odd_indices.one?

  unless odd_indices.one?
    left  = build_slice(odd_indices[0], a[odd_indices[0].succ..-1], odd_indices[1], odd_indices[-1], odd_indices[0] + 1)
    right = build_slice(a.length - odd_indices[-1].succ, a[0...odd_indices[-1]], odd_indices[0], odd_indices[-2], 0)
    solutions << left if left
    solutions << right if right
  end

  return "NO SOLUTION" if solutions.include?("NO SOLUTION")
  return solutions.sort.first * ","
end

def build_slice(length, from, left, right, offset)
  left  -= offset
  right -= offset
  slice_size   = (right - left).succ
  total_needed = from.length - length
  remainder    = total_needed - slice_size
  return false if (total_needed < 0 || remainder < 0)
  take_left    = [left, remainder].min
  remainder    -= take_left
  left         -= take_left
  take_right   = [from.length - right.succ, remainder].min
  remainder    -= take_right
  right        += take_right
  return left+offset,right+offset
end

def shrink_biggest_half(list, split)
  return "NO SOLUTION" if((split + 0.5) == list.length / 2.0)
  left_half  = list[0...split]
  right_half = list[split+1..-1]
  delta = (left_half.length - right_half.length).abs
  return  left_half.length > right_half.length ? [0,delta - 1] : [split.succ,split + delta]
end

def assert_solved(solution, expected)
  puts "Match #{solution}" if solution == expected
  puts "Mismatch. Expected: #{expected}, Got: #{solution}" if solution != expected
end

# Tactic, if sum is odd:
#   pick odd number furthest from side
#   pick slice between other extreme odd numbers, grow slice (favoring left) until size of distance from size. If not possible, attempt other side


# Example
#
assert_solved solution([1,2,2,2,2,1,2,1,1,1,2,2,2,2,1,2,2,2,1,2,1,2,1,2,2,2,1,1,1,2,1,1,2,1,1,2,1,2,2,1,1,1,2,1,2,2,2,1,2,1,2,2,1,2,2,1,2,1,2,2,1,2,1,1,1,2,1,2,2,1,1,2,2,2,1,2,1,1,1,1,1,2,2,1,2,1,1,2,2,2,2,1,2,1,2,1,1,2,1,2,2,2,1,2,1,1,2,2,1,1,1,2,1,2,2,1,1,2,2,2,2,2,1,2,2,1,2,2,1,1,2,2,1,1,1,1,2,1,1,1,1,1,1,1,2,2,1,1,2,1,2,2,1,1,1,1,1,1,2,2,1,2,1,2,2,2,2,2,1,1,2,1,2,1,1,1,1,2,2,2,1,2,1,2,2,2,2,2,2,2,1,1,1,1,2,1,1,2,2,2,2,2,2,1,2,1,2,1,2,2,2,1,2,2,1,2,2,1,1,1,1,2,1,2,1,1,2,2,1,1,1,2,2,2,1,2,1,2,2,2,1,2,1,1,2,1,2,1,1,2,1,1,2,2,1,2,1,1,2,1,2,1,2,1,1,2,2,1,2,2,1,2,2,1,2,2,2,1,2,1,1,2,2,1,2,2,2,2,1,1,2,1,1,2,1,2,2,2,1,2,1,2,1,1,2,1,1,2,1,1,1,2,1,1,2,1,2,2,1,1,2,2,2,1,1,2,2,2,2,2,1,2,1,2,2,1,2,1,2,1,1,2,1,2,1,1,1,2,2,2,2,2,2,1,1,1,2,2,1,2,2,2,2,1,2,1,2,2,1,2,2,1,1,2,2,1,2,2,2,2,1,2,1,1,2,1,1,1,2,1,1,1,2,2,2,2,1,2,2,1,1,2,1,1,2,2,2,2,2,2,1,2,1,1,1,2,1,1,2,1,2,1,2,2,2,2,2,2,1,2,2,1,2,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,1,1,1,2,1,1,2,1,1,2,1,1,1,2,1,1,1,2,1,1,2,2,1,2,2,2,2,2,2,2,1,1,2,2,1,1,1,2,2,2,1,1,1,2,1,1,1,1,1,2,2,1,2,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,1,1,2,2,1,1,2,1,1,1,2,2,2,2,2,1,2,1,2,1,2,2,2,1,1,1,1,2,2,2,2,1,2,2,1,1,2,2,2,1,1,2,1,2,2,1,1,2,2,1,2,1,1,2,1,2,1,1,1,2,2,2,2,2,2,1,1,2,2,2,2,1,2,2,1,2,1,2,2,1,1,2,2,2,2,1,2,1,1,2,1,1,2,1,1,2,1,1,2,1,2,2,1,1,1,1,2,1,1,2,1,1,1,2,2,2,2,2,1,1,2,2,1,1,2,1,2,2,2,2,2,1,2,1,1,1,2,2,2,2,2,2,1,1,1,1,1,1,2,1,2,2,2,2,2,2,2,2,2,1,1,1,2,1,1,2,2,1,1,2,2,1,2,1,2,1,2,2,2,1,1,1,2,2,2,1,1,2,1,1,2,2,1,1,1,2,2,2,2,1,1,1,2,1,2,1,1,2,1,2,2,2,2,1,2,1,1,2,1,2,2,1,2,1,1,2,1,2,2,2,1,1,1,1,2,2,2,1,2,2,1,1,2,1,2,2,1,1,1,2,2,2,1,2,2,1,2,2,2,1,2,1,1,2,2,1,2,1,2,1,2,2,1,2,1,1,2,2,2,1,2,1,2,1,1,1,2,2,1,2,1,2,1,2,2,1,2,2,1,1,2,2,2,2,1,1,1,2,2,2,1,1,1,2,1,2,1,1,2,2,2,1,2,1,2,2,2,1,1,1,2,2,2,1,1,1,1,2,2,2,1,2,1,2,2,1,2,2,2,2,1,2,1,1,2,2,1,1,1,2,2,2,2,1,2,2,1,2,1,1,1,2,1,2,2,1,1,2,2,1,2,1,1,1,1,1,2,1,1,2,1,1,2,1,1,2,1,1,1,2,2,2,2,2,1,2,2,1,1,1,1,2,2,2,2,1,1,2,1,2,1,1,2,1,1,1,2,2,1,2,2,1,2,2,2,1,2,1,2,2,2,2,2,2,1,2,2,2,1,1,2,1,1,1,1,2,2,1,1,1,1,1,2,1,1,1,2,1,2,2,1,2,2,2,1,2,1,2,2,2,1,2,1,2])\
  , "0,996"
assert_solved solution([2, 2, 1, 2, 2, 1, 2, 2, 1, 2, 2, 2, 2, 2]), "3,11"
assert_solved solution([2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]), "6,64"
assert_solved solution([1, 3, 5, 2]), "1,3"
assert_solved solution([2, 2, 2, 1, 4, 4, 3, 6, 5, 8, 7, 10, 9, 2, 2, 2, 2]), "3,10"
assert_solved solution([2, 2, 1, 4, 3, 6, 6, 5, 8, 8, 7, 2, 2, 2, 9, 4, 4, 4, 4, 4, 4, 4]), "3,19"

assert_solved solution([4,5,3,7,2]), "1,2" # Tactic, pick middle, leave 2 moves
assert_solved solution([2,5,4]), "NO SOLUTION"
# One move
assert_solved solution([7]), "NO SOLUTION"
assert_solved solution([2,4,6,7,10,8,6]), "NO SOLUTION"
assert_solved solution([6]), "0,0" # Pick all
assert_solved solution([2,5,4,4,5,3,6,1]), "0,7" # Pick all
assert_solved solution([3,5,7,9]), "0,3" # Pick all
assert_solved solution([2,6,8,4,2,8,8,6]), "0,7" # Pick all

# One Odd Half L
assert_solved solution([7,2]), "1,1" # Pick even half
assert_solved solution([8,3,2,2,2,2]), "2,4" # Leave 2 moves
assert_solved solution([2,2,1,2,2,2,2,2,4]), "3,6" # Leave matched sides

# One Odd Half $
assert_solved solution([4,11]), "0,0" # Leave no moves
assert_solved solution([4,2,2,2,1,6,6]), "0,1" # Leave matched sides
assert_solved solution([2,4,2,6,4,2,6,8,2,4,2,12,99,2,4,2,88]), "0,7"

#three odd elements, last odd element remains
assert_solved solution([1,3,5]), "0,1" # Leave no moves
assert_solved solution([2,2,1,2,2,1,2,2,1,2,2]), "0,5"
assert_solved solution([2,2,2,2,1,4,4,3,6,6,6,6,6,5,8,8,8,8,8,8,8,8]), "3,7"

#three odd elements, first odd element remains
assert_solved solution([2,2,1,2,2,1,2,2,1,2,2,2,2,2]), "3,11"
assert_solved solution([2,2,1,4,4,3,6,6,6,5,8,8,8,8,8,8,8,8]), "3,15"
assert_solved solution([2,2,2,2,2,1,3,6,6,5,8,8,8,8,8,8,8,8,8,8]), "6,14"

# extreme values
assert_solved solution([2,2,2,1,4,4,3,6,5,8,7,10,9,2,2,2,2]), "3,10"
assert_solved solution([2,1,4,3,6,6,5,8,8,7,2,2,2,9,4,4,4,4,4,4,4]), "2,19"





