class Tree
  attr_accessor :value, :left, :right, :count

  def initialize
    self.value = self.left = self.right = nil
    self.count = 0
  end

  def insert(node, rank=0)
    self.count += 1
    if ! self.value
      self.value = node
      return rank
    elsif self.value < node then (self.right ||= Tree.new).insert(node, rank + (self.left ? self.left.count + 1 : 1))
    else (self.left ||= Tree.new).insert(node, rank)
    end
  end

  def self.build_counts(nodes)
    tree = Tree.new
    left_counts = nodes.map{|node| tree.insert(node) }

    tree = Tree.new
    right_counts = nodes.reverse_each.map{|node| tree.insert(node) }.reverse
    return left_counts, right_counts
  end
end
