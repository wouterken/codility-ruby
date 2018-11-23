class RopeBrokeException < Exception; end

def solution(a, b, c)

  TreeLinks.init(c)
  tree = Tree.new

  ropes = a.zip(b).map.with_index {|params, i| Rope.new(*([i] + params)) }

  return c.each.with_index { |position, i| return i if broke = tree.attach(position, ropes[i]) }.length
end


class Tree
  def initialize
    @root, @nodes = Node.new(), {}
  end

  def attach(position, rope)
    begin
      @nodes[rope.index] = (position == -1 ? @root : @nodes[position]).attach(rope)
    rescue RopeBrokeException
      return true
    end
    return false
  end
end


class TreeLinks
  def self.init(count_array)
    @@points = count_array
    @@counts = count_array.each_with_object(Hash.new(0)) { |value,counts| counts[value] += 1 }
  end

  def self.is_link_node(index)
    @@counts[@@points[index]] == 1
  end
end


class Node

  attr_accessor :parent, :available, :attached

  def initialize(max=1/0.0, parent=nil)
    @parent = parent
    @available = max
  end

  def attach(rope)
    min_weight = [rope.max,self.available].min
    new_node = (min_weight < rope.max || TreeLinks.is_link_node(rope.index) ) ? self : Node.new(rope.max, self)
    new_node.available = min_weight
    new_node.weigh_down(rope.weight)
  end

  def weigh_down(weight)
    @available -= weight
    raise RopeBrokeException.new if @available < 0
    parent = @parent
    while parent
      parent.available -= weight
      raise RopeBrokeException.new if parent.available < 0
      parent = parent.parent
    end
    self
  end

end

class Rope
  attr_accessor :index, :max, :weight
  def initialize(index, max, weight)
    self.index, self.max, self.weight = index, max, weight
  end
end
