require 'pry-byebug'
require 'ostruct'
require_relative 'chromium'

class Tree

  attr_accessor :value, :position, :left, :right, :smaller, :larger, :parent, :size
  INF = Float::INFINITY

  def initialize(parent=nil)
    self.parent = parent
    self.position = nil
    self.value = nil
    self.size = 0
    self.smaller = OpenStruct.new({left: 0, right: 0})
    self.larger = OpenStruct.new({left: 0, right: 0})
  end

  def left
    @left ||= Tree.new(self)
  end

  def right
    @right ||= Tree.new(self)
  end

  def empty?
    self.position.nil?
  end

  def [](position)
    return nil if self.empty?
    return self if self.position == position
    case position
    when 0...self.position     then self.left[position]
    when self.position+1...INF then self.right[position]
    end
  end

  def []=(position, value)
    # binding.pry
    self.insert(position, value)
  end

  def left_parent
    self.parent && self.parent.position < position ?
         self.parent :
         nil
  end

  def right_parent
    self.parent && self.parent.position > position ?
         self.parent :
         nil
  end

  def find_insert_node(position)
    current_node = self
    while !current_node.empty?
      return current_node if position == current_node.position
      if position < current_node.position
        break if current_node.left.empty?
        current_node = current_node.left
      else
        break if current_node.right.empty?
        current_node = current_node.right
      end
    end
    return current_node
  end

  def left_neighbor(position)
    insertion_node = find_insert_node(position)

    if insertion_node.position >= position
      insertion_node = insertion_node.parent until insertion_node.nil? || insertion_node.position < position
    end
    return insertion_node
  end

  def right_neighbor(position)
    insertion_node = find_insert_node(position)

    if insertion_node.position <= position
      insertion_node = insertion_node.parent until insertion_node.nil? || insertion_node.position > position
    end
    return insertion_node
  end

  def insert(position, value)
    if self.empty?
      self.position = position
      self.value = value
      self.size = 1
      return OpenStruct.new({left: 0, right: 0})
    else
      self.size += 1
      case position
      when 0...self.position
        collection = self.smaller
        inserts    = self.left.insert(position, value)
        inserts.left += 1
        self.smaller.left  += inserts.left + self.right.size
        self.smaller.right += inserts.right
        return OpenStruct.new({left: inserts.left + self.right.size, right: inserts.right})
      when self.position+1...INF
        collection = self.larger
        inserts    = self.right.insert(position, value)
        inserts.right += 1
        self.larger.left += inserts.left
        self.larger.right += inserts.right + self.left.size
        return OpenStruct.new({left: inserts.left, right: inserts.right + self.left.size})
      end
    end
  end


  def list
    return if empty?
    [self.left.list, self.value, self.right.list].compact
  end

  def inspect
    "N[:'#{self.value}@#{self.position}']"
  end

  def self.accumulate(nodes)
    tree = Tree.new
    step_size = total = 0
    values = nodes.each.with_index.sort_by(&:first)
    direction = last = nil
    values.each do |height, position|
      change = 1
      right = position > last if last
      # binding.pry if height == 3
      if right
        if neighbor = tree.left_neighbor(position)
          parent = false
          counted = 0
          while neighbor
            if parent
              count = neighbor.smaller.left
              # neighbor.smaller.left = 0
              # neighbor.larger.left = 0
              counted += count
              change += count
            else
              count = neighbor.smaller.left
              neighbor.smaller.left = 0
              neighbor.larger.right = 0
              counted += count
              change += count
            end
            neighbor = neighbor.left_parent
            parent = true
          end
        end
        #   lefts = 0
        #   while neighbor
        #     change += neighbor.smaller.left+ neighbor.larger.left
        #     lefts += neighbor.smaller.left + neighbor.larger.left
        #     neighbor.larger.left = 0
        #     neighbor.smaller.left = 0
        #     neighbor = neighbor.left_parent
        #   end
        # end
      elsif last
        if neighbor = tree.right_neighbor(position)
          parent = false
          counted = 0
          while neighbor
            if parent
              count = neighbor.larger.right
              neighbor.larger.right = 0
              neighbor.smaller.right = 0
              counted += count
              change += count
            else
              count = neighbor.larger.right
              neighbor.smaller.left = 0
              neighbor.larger.right = 0
              counted += count
              change += count
            end
            neighbor = neighbor.right_parent
            parent = true
          end
          # rights = 0
          # while neighbor
          #   change += neighbor.larger.right + neighbor.smaller.right
          #   rights += neighbor.larger.right + neighbor.smaller.right
          #   neighbor.smaller.right = 0
          #   neighbor.larger.right = 0
          #   neighbor = neighbor.right_parent
          # end
        end
      end

      # binding.pry if height == 4
      tree[position] = height
      total += (step_size += change)
      last = position
    end
    total % 1_000_000_007
  end
end

def solution2(values)
  Tree.accumulate(values)
end


def find_unequal
  (3..7).each do |i|
    values = i.times.with_index(1).to_a.map(&:last)
    values.permutation.each do |values|
      return values if solution2(values) != solution(values)
    end
  end
end
# puts "Unequal #{find_unequal}"
# values = [1,3,2,4] # 11
# values = [2,4,1,3] # 13
# values = [3,1,2,4] # 14
# values = [2,1,3,4] # 12
# values = [4,2,3,1] # 11
# values = [1,2,4,3,5] # 16
# values = [1,4,2,3,5] # 19
# values = [1, 4, 2, 5, 3] # 18
# values = [1,11,5,8,7,10,3,9,6,4,2,44,36,27,81,95,41] # 761
values = [5,4,1,2,3, 6]
puts solution2(values)
solution(values)
# binding.pry

puts 3