require 'set'
require 'pry-byebug'
require_relative 'chromium'

class Tree
  attr_accessor :value, :left, :right, :count, :last_height
  attr_accessor :lpaths, :rpaths, :parent, :direction

  def self.map=(value)
    @@map = value
  end

  def self.map
    @@map
  end

  def initialize(parent= nil)
    self.parent = parent
    self.value = self.left = self.right = nil
    self.count = self.lpaths = self.rpaths = 0
  end

  def height
    Tree.map[self.value]
  end

  def paths
    (self.lpaths + self.rpaths + self.count) % 1_000_000_007
  end

  def rparent
    parent && parent.left == self ? parent : nil
  end

  def lparent
    parent && parent.right == self ? parent : nil
  end

  def left
    @left ||= Tree.new(self)
  end

  def right
    @right ||= Tree.new(self)
  end

  def empty?
    self.count.zero?
  end

  def insert(node, last=nil, direction=nil)
    height = Tree.map[node]

    self.count += 1

    if ! self.value
      self.value = node
      self.lpaths = lpaths
      self.rpaths = rpaths
      left_neighbor, right_neighbor = nil, nil
      if self.parent
        if self.parent.value < node
          parent = left_neighbor = self.parent
          parent = parent.parent while parent && parent.value < node
          right_neighbor = parent if parent
        else
          parent = right_neighbor = self.parent
          parent = parent.parent while parent && parent.value > node
          left_neighbor = parent if parent
        end
      end
      # puts "Inserting #{self.height} #{self.lpaths},#{self.rpaths}"
      [0,0, left_neighbor, right_neighbor, self]
    elsif self.value < node
      # self.lpaths += self.rpaths
      lincrease, rincrease, left_neighbor, right_neighbor, inserted = self.push_right(node)
      rincrease += 1 + self.left.count
      self.left.rpaths += self.left.count

      self.lpaths += lincrease

      if self.last_height && last && direction
        min, max = [node, last.value].sort
        levels = height - self.last_height
        left_neighbor_paths = left_neighbor ? left_neighbor.send(direction == :left ? :rpaths : :lpaths) : 0
        right_neighbor_paths = right_neighbor ? right_neighbor.send(direction == :left ? :rpaths : :lpaths) : 0
                                                        # - self.right_neighbor(node).lpaths
        # binding.pry
        stp = direction == :left ?  (left_neighbor_paths - right_neighbor_paths) : (right_neighbor_paths - left_neighbor_paths)
        puts "R:Step #{stp}, levels #{levels}"
        # binding.pry
        rincrease = rincrease + (levels * stp) % 1_000_000_007
        left_neighbor = nil
      end

      self.rpaths += rincrease

      self.last_height = height
      self.direction = :right


      # puts "Visiting R#{self.height} #{self.lpaths},#{self.rpaths}"
      [lincrease, rincrease, left_neighbor, right_neighbor, inserted]
    else
      # self.rpaths += self.lpaths

      lincrease, rincrease, left_neighbor, right_neighbor, inserted = self.push_left(node)
      lincrease += 1 + self.right.count
      self.right.lpaths += self.right.count
      self.rpaths += rincrease

      if self.last_height && last && direction
        min, max = [node, last.value].sort
        levels = height - self.last_height
        right_neighbor_paths = right_neighbor ? right_neighbor.send(direction == :left ? :rpaths : :lpaths) : 0
        left_neighbor_paths = left_neighbor ? left_neighbor.send(direction == :left ? :rpaths : :lpaths) : 0
                                                      # - self.left_neighbor(node).lpaths
        step =  (right_neighbor_paths - left_neighbor_paths)
        puts "L:Step #{step}, levels #{levels}"
        lincrease = lincrease + (levels * (right_neighbor_paths - left_neighbor_paths) ) % 1_000_000_007
        right_neighbor = nil
      end

      self.last_height = height
      self.direction = :left
      # self.rpaths += rincrease

      self.lpaths += lincrease

      # puts "Visiting L#{self.height} #{self.lpaths},#{self.rpaths}"
      [lincrease, rincrease, left_neighbor, right_neighbor, inserted]
    end
  end

  def find(node)
    # Propagate lprop, rprop
    if self.value == node
      return self
    elsif self.value < node
      self.right.find(node)
    else
      self.left.find(node)
    end
  end

  def increment_lefts(height, amt)
    self.lpaths += (self.left.count + 1) * (amt + 1)
  end

  def increment_rights(height, amt)
    self.rpaths += (self.right.count + 1) * (amt + 1)
  end

  def push_left(node)
    self.left.insert(node)
  end

  def push_right(node)
    self.right.insert(node)
  end

  def inspect(indent='')
    "\n#{indent}V:#{Tree.map[self.value]}(#{self.lpaths},#{self.rpaths})(#{self.paths})" +
    (self.left.empty? ? '' : self.left.inspect(indent + '  '))  +
    (self.right.empty? ? '' : self.right.inspect(indent + '  '))
  end

  def sum
    return 0 if self.empty?
    self.lpaths + self.rpaths + self.right.sum + self.left.sum
  end

  def print
    puts self.inspect
  end
end


def solution2(values)
  by_height = values.each.with_index.sort_by(&:first).map.with_index(1) do |(_, position), height|
    [height, position]
  end.to_h

  by_indices = by_height.invert
  Tree.map = by_indices
  tree = Tree.new
  inserted = nil
  last = nil
  by_height.each do |height, position|
    direction =  position < last ? :left : :right if last
    _, _, ln, rn, inserted = tree.insert(position, inserted, direction)
    inserted = inserted.dup
    puts "#{ln && ln.height}x#{height}x#{rn && rn.height}"
    tree.print
    last = position
  end
  puts tree.paths
  tree.paths
end

def find_unequal
  (3..11).each do |i|
    values = i.times.with_index(1).to_a.map(&:last)
    values.permutation.each do |values|
      return values if solution2(values) != solution(values)
    end
  end
end

# find_unequal
#
# solution([ 2,1, 3])
# solution2([ 2,1, 3])

# solution([ 1, 3, 2])
# solution2([ 1, 3, 2])
# # # exit(0)
# solution([ 1, 3, 4, 2])
# solution2([ 1, 3, 4, 2])

solution([ 2, 4, 1, 5, 3])
# solution2([ 2, 1, 4, 3])
# solution([ 2, 4, 1, 3])
# solution2([ 2, 4, 1, 3])
# solution([ 3, 1, 2, 4])
# solution2([ 3, 1, 2, 4])
# puts solution([1, 3, 4, 2])
# solution([ 1, 3, 2, 4])
# solution2([ 1, 3, 2, 4])
# solution([1,11,5,8,7,10,3,9,6,4,2,44,36,27,81,95,41])
# solution2([1, 11, 5, 8, 7, 10, 3, 9, 6, 4, 2, 15, 13, 12, 16, 17, 14])
# values = 50_000.times.map{|i| i}.shuffle
# puts solution([1, 3, 4, 2])
# puts solution2([1, 3, 4, 2])
# puts solution2([1,11,5,8,7,10,3,9,6,4,2,44,36,27,81,95,41])

# solution2(values)
# solution([ 2, 1,  3])
# puts solution2([ 2, 1,  3])

# 4, we know there's 3 smaller
# 8, we know there's 7 smaller -
#