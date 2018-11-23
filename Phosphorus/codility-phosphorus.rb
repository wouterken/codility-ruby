require 'set'

def solution(a, b, c)
  c = Set.new(c)
  return 0 if c.empty?

  node_map = build_node_map(a.zip(b), c)
  c.each{|prisoner| return -1 if node_map[prisoner].neighbors.length == 1}
  total = get_visit_order_from(node_map[0]).reverse_each.map(&:get_number_of_guards).inject(:+)
  total = node_map[0].up_exit && node_map[0].leaf? ? total + 1 : total
  return total
end

def build_node_map(links, c)
  node_map = {}
  links.each do |left, right|
    lefty = node_map[left] ||= Node.new(left, c.include?(left))
    righty = node_map[right] ||= Node.new(right, c.include?(right))
    lefty.neighbors << righty
    righty.neighbors << lefty
  end
  return node_map
end


def get_visit_order_from(node)
  visited = Set.new
  to_visit = [node]
  visit_order = []
  while to_visit.length > 0
    visiting = to_visit.pop
    unless visited.include?(visiting)
      visit_order << visiting
      visited << visiting
      visiting.neighbors.each do |neighbor|
        next if visited.include?(neighbor)
        neighbor.parent = visiting
        to_visit << neighbor
      end
    end
  end

  return visit_order
end


class Node
  attr_accessor :index, :parent, :neighbors, :up_exit, :down_exit, :prisoner
  def initialize(index, prisoner)
    self.index = index
    self.prisoner = prisoner
    self.neighbors = []
    self.down_exit = true
  end

  def prisoner?
    self.prisoner
  end

  def leaf?
    self.neighbors.length == 1
  end

  def count_exits
    up_exits = down_exits = siblings = 0
    self.neighbors.each do |neighbor|
      next if parent == neighbor
      siblings += 1
      up_exits += 1 if neighbor.up_exit
      down_exits += 1 if neighbor.down_exit
    end
    return up_exits, down_exits, siblings
  end

  def get_number_of_guards
    up_exits, down_exits, siblings = self.count_exits
    self.up_exit, self.down_exit, count = case true
    when self.prisoner?
      [true, false, down_exits]
    when siblings == down_exits
      [self.up_exit, self.down_exit, 0]
    when down_exits == 0
      [(up_exits > 0), false, 0]
    else
      [false, up_exits == 0, up_exits != 0? 1: 0]
    end
    return count
  end
end
