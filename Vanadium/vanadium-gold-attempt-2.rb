$profile = false
# Winter is coming and Victor is going to buy some new lights. In the store, lights are available in 10 colors, numbered from 0 to 9. They are connected together in a huge chain. Victor can choose any single segment of the chain and buy it.

# This task would be easy if it weren't for Victor's ambition. He wants to outdo his neighbors with some truly beautiful lights, so the chain has to look the same from both its left and right sides (so that both neighbors see the same effect).

# Victor is a mechanic, so after buying a segment of the chain, he can rearrange its lights in any order he wants. However, now he has to buy a chain segment that will satisfy above condition when its lights are reordered. Can you compute how many possible segments he can choose from?

# Write a function:

# class Solution { public int solution(String S); }

# that, given a description of the chain of lights, returns the number of segments that Victor can buy modulo 1,000,000,007. The chain is represented by a string of digits (characters from '0' to '9') of length N. The digits represent the colors of the lights. Victor can only buy a segment of the chain in which he can reorder the lights such that the chain will look identical from both the left and right sides (i.e. when reversed).

# For example, given:

#     S = "020022010"
#
#     "20002"
# the function should return 11. Victor can buy the following segments of the chain:

# "0", "2", "0", "0", "2", "00", "020", "200", "002", "2002", "02002"
# Note that a segment comprising a single "0" is counted three times: first it describes the subchain consisting of only the first light, then the subchain consisting of the third light and finally the subchain consisting of the fourth light. Also note that Victor can buy the whole chain ("02002"), as, after swapping the first two lights, it would become "20002", which is the same when seen from both from left and right.

# Assume that:

# string S consists only of digits (0−9);
# the length of S is within the range [1..200,000].
# Complexity:

# expected worst-case time complexity is O(N);
# expected worst-case space complexity is O(1) (not counting the storage required for input arguments).

require 'pry'
require 'pry-byebug'

def count_fails(str)
  all_chars = str.chars
  total_length = all_chars.length
  fails = 0

  last_index = -1
  all_chars.each_cons(2).with_index(1) do |(left, right), ri|

    if left != right
      li = ri - 1

      length = 2
      fails += 1
      # puts "Fail at #{li}x#{ri}"
      # puts "Fail: #{li},#{ri}"
      even = Hash.new(true)
      even[left] = even[right] = false
      odds  = 2

      until length + li >= total_length
        length        += 1
        ri            = (li + length - 1)
        right         = all_chars[ri]
        even[right]   = !even[right]
        odds          += even[right] ? -1 : 1

        offset_odds   = odds
        offset_even   = even.dup

        offset_ri     = ri
        offset_li     = li

        while true

          if offset_odds > 1
            # puts "Fail at #{offset_li}x#{offset_ri}"
            fails += 1
          end

          offset_li -= 1
          break if offset_li == last_index || offset_li < ri - length - 2

          offset_right              = all_chars[offset_ri + 1]
          offset_left               = all_chars[offset_li]

          offset_even[offset_right] = ! offset_even[offset_right]
          offset_even[offset_left]  = ! offset_even[offset_left]

          offset_odds  += (offset_even[offset_right] ? -1 : 1) + (offset_even[offset_left] ? -1 : 1)

          offset_ri -= 1
        end
      end
      last_index = li
    end
  end

  fails
end


def solution(str)
  starts = Time.now
  res = fact(str.length) - count_fails(str)
  ends = Time.now
  puts "Took #{ends - starts}" if $profile
  res
end

def fact(n)
  case n
  when 1 then 1
  else n + fact(n - 1)
  end
end

# def build_nested(n)
#   case n
#   when 1 then [[EVEN], [ODD]]
#   else
#     nested = build_nested(n - 1)
#     nested.flat_map do |smaller|
#       [
#         [EVEN] + smaller,
#         [ODD] + smaller
#       ]
#     end
#   end
# end

# def nested_counters
#   Hash[build_nested(10).map do |key|
#     [key, 1]
#   end]
# end

# def even?(val)
#   val == EVEN
# end

# def solution(str)
#   counter = 1
#   current_state = 10.times.map{ EVEN }
#   total         = 0
#   str.each_char do |char|
#     total += counter
#     current_state[char.to_i] = current_state[char.to_i] == EVEN ? ODD : EVEN
#     counter += 1 if current_state.count(&method(:even?)) > 8
#   end
#   total
# end


# def build_id(substring)
#   ($identifiers ||= {})[substring] ||= begin
#     unique = {}
#     forwards = substring.each_char.map do |char|
#       unique[char] ||= unique.size
#     end.join
#   end
# end

# def substring_matches(substr, counts=nil)
#   substr = build_id(substr)
#   $substring_matches ||= {}
#   $substring_matches[substr] ||= begin
#     counts ||= begin
#       cnts = Hash.new(0)
#       substr.each_char do |c|
#         cnts[c] += 1
#       end
#       cnts
#     end
#     does_match = case substr.length.even?
#     when true then counts.values.all?(&:even?)
#     else counts.values.count(&:odd?) == 1
#     end
#     counts[substr[0]] -= 1
#     (does_match ? 1 : 0 ) + (substr.length > 1 ? substring_matches(substr[1..-1], counts) : 0)
#   end
# end

#
puts solution("02002") # 11
puts solution("03113") # 10
puts solution("122151") # 13
puts solution("1234554321") # 23
puts solution("1221551221") # 41
puts solution("122151121") # 22
puts solution("3759537919528750263297298647926144900705758776957360913510589342151316525212857604167440502811683427") # 181
puts solution("8444484884848484844888848844884448488884848484884484888888848484484444848884844484888488888444488844") # 3781
puts solution("484889") # 13
puts solution("020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020200202002020020200202002020020200202002020020200202002020020200202002020020200202002020020202")
#770536
#
#
#
# "001101011001"
#
#
# '0'    = 1
# '00'   = 3,  '01'.= 2
# '000'  = 6,  '001' = 5,  '010'  = 4, '012' = 3,
# '0000' = 10, '0011' = 9, '0110' = 7, '0001' = 8, '0100' = 7, '0112' = 7, '0012' = 6, 0121 = '5', 0120 = '4', '0123' = 4
#
#
# '00110'
