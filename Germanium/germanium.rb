require 'pry-byebug'
# Task description
#
# You are playing a game with N cards. On both sides of each card there is a positive integer. The cards are laid on the table. The score of the game is the smallest positive integer that does not occur on the face-up cards. You may flip some cards over. Having flipped them, you then read the numbers facing up and recalculate the score. What is the maximum score you can achieve?
#
# Write a function:
#
#     def solution(a, b)
#
# that, given two arrays of integers A and B, both of length N, describing the numbers written on both sides of the cards, facing up and down respectively, returns the maximum possible score.
#
# For example, given A = [1, 2, 4, 3] and B = [1, 3, 2, 3], your function should return 5, as without flipping any card the smallest positive integer excluded from this sequence is 5.
#
# Given A = [4, 2, 1, 6, 5] and B = [3, 2, 1, 7, 7], your function should return 4, as we could flip the first card so that the numbers facing up are [3, 2, 1, 6, 5] and it is impossible to have both numbers 3 and 4 facing up.
#
# Given A = [2, 3] and B = [2, 3] your function should return 1, as no matter how the cards are flipped, the numbers facing up are [2, 3].
#
# Assume that:
#
#         N is an integer within the range [1..100,000];
#         each element of arrays A, B is an integer within the range [1..100,000,000];
#         input arrays are of equal size.
#
# Complexity:
#
#         expected worst-case time complexity is O(N);
#         expected worst-case space complexity is O(N) (not counting the storage required for input arguments).
#


def mark_using(using, used, uncertain)
  used[using] = true
  neighbor_sets = uncertain.delete(using).tap{|ns| ns && ns.each{|n| n && n.delete(using) }}
  neighbor_sets && neighbor_sets.each do |neighbors|
    using = (neighbors && neighbors.length == 1) ? neighbors.first : nil
    mark_using(using, used, uncertain)
  end
end

def solution(_a, _b)
  blanks = _a.length.times.map{|i| [] }
  _a.zip(_b).each.with_index do |(a,b),i|
    blanks[a - 1] << i if a <= blanks.length
    blanks[b - 1] << i if b <= blanks.length
  end
  used = {}
  uncertain = Hash.new{|h,k| h[k] = []}
  best = 0
  blanks.each.with_index do |opts, index|
    unused = opts.uniq.reject{|opt| used.include?(opt) }
    break unless unused.any?
    if unused.length == 1
      mark_using(unused.first, used, uncertain)
    else
      unused.each{|uu| uncertain[uu] << unused }
    end
    best = [best, index.succ].max
  end
  best.succ
end

puts solution([4, 2, 1, 6, 5] , [3, 2, 1, 7, 7])

