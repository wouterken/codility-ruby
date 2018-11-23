require 'pry-byebug'
require_relative 'chromium'

class Node
  attr_accessor :node, :position
  def initialize(node, position)
    self.node, self.position =  node, position
  end
end

def N(node, position)
  Node.new(node, position)
end

class RankTree

  LEFT  = :left
  RIGHT = :right

  attr_accessor :value, :left, :right, :count, :lefts, :rights, :propagate_rights, :propagate_lefts, :parent

  def initialize(parent = nil)
    self.value = self.left = self.right = nil
    self.count = self.lefts = self.rights = 0
    self.propagate_lefts = 0
    self.propagate_rights = 0
    self.parent = parent
  end

  def insert(node)
    if ! self.value
      self.value = node
      return 0,0
    elsif self.value.position < node.position
      self.left.propagate_rights += 1 if self.left
      return self.push_right(node)
    else
      self.right.propagate_lefts += 1 if self.right
      return self.push_left(node)
    end
  end

  def get_rightmost_neighbor(position)
    current_node = self
    while current_node
      if position == current_node.value.position
        break
      elsif position < current_node.value.position
        break unless current_node.left
        current_node = current_node.left
      else
        break unless current_node.right
        current_node = current_node.right
      end
    end
    if current_node.value.position < position
      until current_node.nil? || current_node.value.position > position
        current_node = current_node.parent
      end
      current_node = get_leftmost_neighbor(current_node.value.position) if current_node
    end
    return current_node
  end

  def get_leftmost_neighbor(position)
    current_node = self
    while current_node
      if position == current_node.value.position
        break
      elsif position < current_node.value.position
        break unless current_node.left
        current_node = current_node.left
      else
        break unless current_node.right
        current_node = current_node.right
      end
    end
    if current_node.value.position > position
      until current_node.nil? || current_node.value.position < position
        current_node = current_node.parent
      end
      current_node = get_rightmost_neighbor(current_node.value.position) if current_node
    end
    return current_node
  end

  def get_rights(position, prop=0)
    neighbor = get_rightmost_neighbor(position).value.position
    self.sum_rights(neighbor)
  end

  def sum_rights(position, prop=0)
    propagate = self.propagate_rights + prop
    if position == self.value.position
      return self.rights + propagate
    elsif position > self.value.position
      return self.right.sum_rights(position, propagate)
    elsif position < self.value.position
      return self.rights + self.left.sum_rights(position, propagate)
    end
  end

  def get_lefts(position, prop=0)
    neighbor = get_leftmost_neighbor(position).value.position
    self.sum_lefts(neighbor)
  end

  def sum_lefts(position, prop=0)
    propagate = self.propagate_lefts + prop
    if position == self.value.position
      return self.lefts + propagate
    elsif position > self.value.position
      return self.lefts + self.right.get_lefts(position, propagate)
    elsif position < self.value.position
      return self.left.get_lefts(position, propagate)
    end
  end

  def push_left(node)
    self.left ||= RankTree.new(self)
    child_left, child_right = self.left.insert(node)
    self.lefts  += child_left + 1
    self.rights += child_right
    [self.lefts, self.rights]
  end

  def push_right(node)
    self.right ||= RankTree.new(self)
    child_left, child_right = self.right.insert(node)
    self.rights += child_right + 1
    self.lefts  += child_left
    [self.lefts, self.rights]
  end
end

def s2(nodes)
  t = RankTree.new
  rnd = nodes.each.with_index.sort_by(&:first)
  last = -1
  step_size = 0
  total = 0
  rnd.each do |h,p|

    # binding.pry if h == 5
    if !t.value
      change = 1
    elsif p < last
      last_rights = t.get_rights(last)
      next_rights = t.get_rights(p)
      change = 1 + next_rights - last_rights
    else
      last_lefts = t.get_lefts(last)
      next_lefts = t.get_lefts(p)
      change = 1 + next_lefts - last_lefts
    end


    # binding.pry if h == 4
    t.insert(N(h,p))


    # change = t.find()
    # change = 1 + (last != -1 ? t.count(p + (look_dir == :left ? -1 : 1), look_dir) : 0)
    puts change
    # puts t.lefts
    step_size += change
    last = p
    total += step_size
  end
  puts "#{total}\n"
  total
end

# rnd = 50_000.times.map{|i|i}.shuffle.each.with_index.sort_by(&:first)
# values = [4 ,2 ,1, 3, 5]
# values = [3, 1, 2]
# values = [3,1,4,2]
# values = [3, 5, 2, 1, 4]
values = [8,4,2,7,3,5,6,1,10,9,18,13,17,14,43,11, 12]
#


def find_unequal
  (3..7).each do |i|
    values = i.times.with_index(1).to_a.map(&:last)
    values.permutation.each do |values|
      return values if s2(values) != solution(values)
    end
  end
end
# puts "Unequal #{find_unequal}"

s2([2,3,5,1,4])
solution([2,3,5,1,4])
#
# s2([2,5,1,3,4])
# solution([2,5,1,3,4])
# #
# s2(values)
# solution(values)
# puts find_unequal

# rt = RankTree.new()
# rt.insert(N(1, 7))
# rt.insert(N(2, 4))
# rt.insert(N(3, 1))

# puts rt.get_rightmost_neighbor(3).value.position

# puts 1