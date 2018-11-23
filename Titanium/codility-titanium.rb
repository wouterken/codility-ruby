# A bracket sequence is considered to be a valid bracket expression if any of the following conditions is true:

# it is empty;
# it has the form "(U)" where U is a valid bracket sequence;
# it has the form "VW" where V and W are valid bracket sequences.
# For example, the sequence "(())()" is a valid bracket expression, but "((())(()" is not.

# You are given a sequence of brackets S and you are allowed to rotate some of them. Bracket rotation means picking a single bracket and changing it into its opposite form (i.e. an opening bracket can be changed into a closing bracket and vice versa). The goal is to find the longest slice (contiguous substring) of S that forms a valid bracket sequence using at most K bracket rotations.

# Write a function:

# int solution(char *S, int K);
# that, given a string S consisting of N brackets and an integer K, returns the length of the maximum slice of S that can be transformed into a valid bracket sequence by performing at most K bracket rotations.

# For example, given S = ")()()(" and K = 3, you can rotate the first and last brackets to get "(()())", which is a valid bracket sequence, so the function should return 6 (notice that you need to perform only two rotations in this instance, though).

# Given S = ")))(((" and K = 2, you can rotate the second and fifth brackets to get ")()()(", which has a substring "()()" that is a valid bracket sequence, so the function should return 4.

# Given S = ")))(((" and K = 0, you can't rotate any brackets, and since there is no valid bracket sequence with a positive length in string S, the function should return 0.

# Assume that:

# string S contains only brackets: '(' or ')';
# N is an integer within the range [1..30,000];
# K is an integer within the range [0..N].
# Complexity:

# expected worst-case time complexity is O(N);
# expected worst-case space complexity is O(N) (not counting the storage required for input arguments).

# Notes/Ideas

# Start from inside
# Work way out
#
# (())
#
#
# Step 1 find leaves, array of pairs
# Step 2 for each leaf:
#   expand as much as possible
#   if touching another leaf - join it and add to list of leaves to expand
#
# Step 3 Identify gaps between leaves



def solution(brackets, max_switches)
  bt = BracketTree.new(brackets)
  # bt.print_compressed
  return bt.max_length_with_switches(max_switches)
end

class BracketTree
  OPEN  = ?(
  CLOSE = ?)

  attr_accessor :leaves_map, :right_bounds_map, :left_bounds_map, :brackets

  def initialize(brackets)
    self.brackets   = brackets
    self.leaves_map = {}
    self.right_bounds_map = {}
    self.left_bounds_map = {}
    self.build_leaves
  end

  def leaves
    leaves_map.keys
  end

  def max_length_with_switches(switches)
    max = self.leaves.map(&:length).max || 0
    unmatched_characters = unmatched

    if unmatched_characters.length > 1 && switches > 0
      left_index, right_index = 0, 1

      middle_index = nil
      while right_index < unmatched_characters.length && left_index < unmatched_characters.length

        even_right_index  = (right_index - left_index).even? ? right_index - 1 : right_index
        left, right       = unmatched_characters[left_index], unmatched_characters[even_right_index]
        distance          = (even_right_index - left_index).succ
        required_switches = distance / 2

        case [unmatched_characters[left_index][:type], unmatched_characters[right_index][:type]]
        when [')','('] then middle_index ||= right_index
        end

        required_switches += 1 if middle_index && (middle_index - left_index).odd?

        if required_switches <= switches
          left_most  = left[:left_leaf]   ? left[:left_leaf].left    : left[:index]
          right_most = right[:right_leaf] ? right[:right_leaf].right : right[:index]
          max = [max, (right_most - left_most).succ].max
          if even_right_index != right_index
            right = unmatched_characters[right_index]
            if right[:right_leaf] && left[:left_leaf] && required_switches < switches
              right_most = right[:right_leaf] ? right[:right_leaf].right : right[:index]
              max = [max, (right_most - left_most)].max
            end
          end
        end

        if (required_switches <= switches || left_index == (right_index - 1)) && right_index < unmatched_characters.length - 1
          right_index += 1
        else
          left_index += 1
        end
      end
    elsif unmatched_characters.length == 1 && switches > 0
      unmatched_char = unmatched_characters.first
      if unmatched_char[:left_leaf] && unmatched_char[:right_leaf]
        max = [
          max,
          (unmatched_char[:right_leaf].left - unmatched_char[:left_leaf].left).succ,
          (unmatched_char[:right_leaf].right - unmatched_char[:left_leaf].right).succ
        ].max
      end
    end
    return max
  end

  def unmatched
    unmatched = 0
    match_map = Hash.new(0)
    self.leaves.each do |leaf|
      match_map[leaf.left] = 1
      match_map[leaf.right + 1] = -1
    end

    matched = 0
    unmatched = []
    brackets.length.times do |i|
      matched += match_map[i]
      if matched.zero?
        left_leaf = self.right_bounds_map[i - 1]
        right_leaf = self.left_bounds_map[i + 1]
        unmatched << { type: brackets[i], index: i, left_leaf: left_leaf, right_leaf: right_leaf }
      end
    end
    unmatched
  end
  def build_leaves
    leaves = []
    brackets.each_char.each_cons(2).with_index do |(left, right), index|
      leaves << Leaf.new(self, index, index + 1) if [left,right] == [OPEN, CLOSE]
    end
    num_leaves = leaves.length
    last_num_leaves = nil
    while num_leaves != last_num_leaves
      expand_leaves(leaves)
      last_num_leaves = num_leaves
      num_leaves = leaves.length
    end
  end

  def delete(leaf)
    if previous_upper_bound = self.leaves_map[leaf]
      self.right_bounds_map.delete(previous_upper_bound)
      self.left_bounds_map.delete(leaf.left)
      self.leaves_map.delete(leaf)
    end
  end

  def update(leaf)
    if previous_upper_bound = self.leaves_map[leaf]
      self.right_bounds_map.delete(previous_upper_bound)
    end
    self.leaves_map[leaf]       = leaf.right
    self.right_bounds_map[leaf.right] = leaf
    self.left_bounds_map[leaf.left] = leaf
  end

  def neighbor(leaf)
    self.right_bounds_map[leaf.left - 1]
  end

  private
    def expand_leaves(to_expand)
      i = 0
      while i < to_expand.length
        leaf = to_expand[i]
        leaf.grow while leaf.can_grow?
        to_expand.push(leaf.join) if leaf.touching?
        i += 1
      end
    end
end

class Leaf
  attr_accessor :tree, :left, :right
  def initialize(tree, left, right)
    self.tree, self.left, self.right = tree, left, right
    self.tree.update(self)
  end

  def length
    (right - left) + 1
  end

  def can_grow?
    left > 0 &&
    right < tree.brackets.length - 1 &&
    tree.brackets[left  - 1] == BracketTree::OPEN &&
    tree.brackets[right + 1] == BracketTree::CLOSE
  end

  def grow
    self.left  -= 1
    self.right += 1
    self.tree.update(self)
  end

  def neighbor
    tree.neighbor(self)
  end

  def touching?
    !!neighbor
  end

  def join
    nbr = neighbor
    tree.delete(self)
    nbr.right = self.right
    self.tree.update(nbr)
    nbr
  end

  def to_s
    "(#{left}, #{right})"
  end
end



##
# Solution assertion
##
def assert_correct(got, expected)
  if (got == expected)
    puts 'match'
  else
    puts "Expected #{expected} got #{got}"
  end
end

assert_correct solution('((((())))', 2), 8
assert_correct solution('((())))(((()))', 0), 6
assert_correct solution('((())))(((()))', 1), 6
assert_correct solution('((())))(((()))', 2), 14
assert_correct solution('(()())', 3), 6
assert_correct solution('))(((', 3), 4
assert_correct solution(')(((', 3), 4
assert_correct solution(')((((', 2), 4
assert_correct solution('))((((((', 3), 6
assert_correct solution('))((((((', 4), 8
assert_correct solution(')(()())(', 0), 6
assert_correct solution(')(()())(', 2), 8
assert_correct solution(')))(((', 2), 4
assert_correct solution(')))(((', 0), 0
assert_correct solution('))()(()(()', 2), 10
assert_correct solution('()(()', 1), 4
assert_correct solution('(()))))(()((()))', 2), 10
assert_correct solution('(((((())(((())))))(((((((((()))((()))((()))((()))((()', 1), 28
assert_correct solution('(((((())(((())))))(((((((((()))((()))((()))((()))((()', 2), 30
assert_correct solution('(((((())(((())))))(((((((((()))((()))((()))((()))((()', 5), 52
assert_correct solution('((()((()((()((())))))))))))))))()(((((((((((((((()))()))()))()))', 4), 32
assert_correct solution('((()((()((()((())))))))))))))))()(((((((((((((((()))()))()))()))', 8), 64
assert_correct solution('))(()))()(()())()))(()())))())())()((()))(()(()()()))(((()((())((())())(()(()(()(()((()())))(()())())((()))(()(()()()())))(()))(()))(()()))()())()))))))(((()()())()))()())()(()()(())))()())((())((()(((()())))(((()()()((()()((()))())((()(())(((())(()()(((((((()((((()())((()((()))(())(((())())(()(()))()()((((()(())((((())()(((())))(((())((()))(()())))))()((()(((()(()())(())))))((((()())())())())(()()()(()()()(()()()((()((()())()()()(((()(())())(())()))))(())())(()()(()()((())))()())())))))(())()()(((()(()((((((())())()(())(((((())()(((()((((())((())))())))())((((())())))(())())))))((())()()))())((()(((((()))()())(()((()()))(())(()))()((()((())(()()((()))(()()((()))(()(())(()(((()(((())())()(()()()()(())()((((((()(()()((((()())()()((((()()())(())))()(())()((()()))(())(()))))))()()())((((()()))(()()()))))))()((()((((()(((())(()(())(())))))()((()())(((())(())())())()(()(()()()()))(((()()(()))(((()))()(()())))((())((((()()()(())((((()()()((())(()))())()))()(()(((((())()))((()))())()(())())((', 10), 400