require 'set'

def solution(a, b, k)
  nodes = Hash.new{|h,k| h[k] = Set.new}
  a.zip(b).each do |left, right|
    nodes[left]  << right
    nodes[right] << left
  end

  root_nodes = get_root_nodes(nodes).to_a
  if root_nodes.length > 1
    new_root = root_nodes[0]
    root_nodes[1..-1].each do |node|
      nodes[new_root].merge(nodes[node])
      nodes.delete(node)
    end
  end
  root_node = root_nodes[0]

  tree = build_tree(root_node, nodes)
  return tree.max_slice(k)
end

class Node
  attr_accessor :node, :children, :depth
  def initialize(node)
    self.node = node
    self.children = []
  end

  def max_child_slice

  end

  def max_slice(k)
    if k >= children.length
      children.map{|c| c.max_slice(k - children.length) }.max
    elsif if k == children.length - 1
      children.map{|c| c.max_slice(k - children.length) }.max + 1
    else
      children.map{|c| c.max_slice(k - children.length) }.min + 1
    end
  end
end

def build_tree(root, nodes, visited=Set.new)
  node = Node.new(root)
  visited << root
  nodes[root].each do |child|
    next unless nodes.include?(child)
    next if visited.include?(child)
    node.children << build_tree(child, nodes,visited)
  end
  node.depth = node.children.any? ? node.children[0].depth + 1 : 0
  return node
end

def print_tree(root, nodes, depth=0, visited=Set.new)
  puts ("----" * depth) + "#{root}"
  visited << root
  nodes[root].each do |child|
    next unless nodes.include?(child)
    next if visited.include?(child)
    print_tree(child, nodes, depth + 1, visited)
  end
end


def get_root_nodes(nodes)

  leaves = nodes.map{|k,v| k if v.length == 1}.compact
  visiting  = Set.new(leaves.dup)
  unvisited = Set.new(Set.new(nodes.keys) - visiting)
  current_path_length = 0

  while unvisited.any?
    next_level = Set.new()

    visiting.each do |node|
      neighbors = nodes[node]
      to_visit = (neighbors & unvisited).first
      unvisited.delete(to_visit)
      next_level << to_visit
    end


    current_path_length += 1
    visiting = next_level
  end
  return visiting
end


A = [5,1,0,2,7,0,6,6,1]
B = [1,0,7,4,2,6,8,3,9]

puts solution(A, B, 2)