require 'pry-byebug'

class KDTree
  attr_accessor :dimensions, :mod, :value, :left, :right, :dimension, :size, :parent
  def initialize(dimensions, mod=0, parent=nil)
    self.dimensions = dimensions
    self.mod        = mod
    self.size       = 0
    self.parent     = parent
  end

  def range_query(indices)
    return if self.dimension.nil?
    raise "Invalid dimensions #{indices.length} expecting < #{self.dimensions}" unless indices.length <= self.dimensions
    indices += [true] * (self.dimensions - indices.length) unless indices.length.eql?(self.dimensions)
    yield_ranges(
      indices,
      case index = indices[self.mod]
      when true   then [true, true, true]
      when Fixnum then [index < dimension, index == dimension, index > dimension]
      when Range  then [index.min <= dimension, index.min <= dimension && index.max >= dimension, index.max >= dimension]
      else             raise "Invalid index encountered #{index}"
      end
    ) do |value|
      yield value
    end
  end


  def empty?
    size.zero?
  end

  def any?
    !empty?
  end

  def distance(a, b)
    a.zip(b).map{|a, b| (a-b) ** 2 }.sum ** 0.5
  end

  def yield_ranges(indices, (query_left, query_center, query_right), &block)
    self.left.range_query(indices, &block) if query_left
    self.dimensions == 1 ?
      (yield value) : self.center.range_query(indices.dup.tap{|i| i.delete_at(self.mod)}, &block) if query_center
    self.right.range_query(indices, &block) if query_right
  end

  def []=(*dimensions, arg)
    insert(dimensions, arg)
  end

  def [](*dimensions, &block)
    as_enum = to_enum(:range_query, dimensions)
    if dimensions.length == self.dimensions &&
       dimensions.all?{|d| d.kind_of?(Fixnum)} then as_enum.first
    elsif block                                then as_enum.each(&block)
    else  as_enum
    end
  end

  def coordinates
    parent = self
    coordinates = []
    while parent = parent.parent
      coordinates[parent.mod] = parent.dimension
    end
    coordinates
  end

  # Search radius
  # def radius_search(*dimensions, radius: 0, path: dimensions, neighbors: [])
  #   raise "Invalid dimensions #{dimensions.length} expecting #{self.dimensions}" unless dimensions.length.eql?(self.dimensions)

  #   center = dimensions.dup
  #   center[self.mod] = self.dimension
  #   if distance(center, dimensions) < radius
  #     radius_search(*dimensions, radius: radius, path: center, neighbors: neighbors)
  #   end
  #   if !left.size.zero?
  #     right = dimensions.dup
  #     right[right.mod] = right.dimension
  #     if distance(right, )
  #   end
  #   if !right.size.zero?
  #   end
  # end

  def insert_nearest(nearest_n, n, value, distance)
    if nearest_n.length >= n
      farthest = nearest_n.max_by{|x| x[:distance]}
      return if farthest[:distance] > distance
      nearest_n.delete(farthest)
    end
    nearest_n << {
      distance: distance,
      value: value
    }
  end
  # # N Nearest neighbors
  # def nearest(*dimensions, n:1, nearest_n:[], root: true, path: dimensions)
  #   raise "Invalid dimensions #{dimensions.length} expecting #{self.dimensions}" unless dimensions.length.eql?(self.dimensions)
  #   dimension = dimensions[self.mod]
  #   if self.dimension == dimension
  #     dimensions.delete_at(self.mod)
  #     path.delete_at(self.mod)
  #     if dimensions.any?
  #       self.center.nearest(dimensions, n: n, nearest_n: nearest_n, root: false, path: path)
  #     else
  #       insert_nearest(nearest_n, n, self.value, 0)
  #     end
  #   elsif dimension < self.dimension
  #     self.left.insert(dimensions)
  #   elsif dimension > self.dimension
  #     self.right.insert(dimensions)
  #   end
  #   binding.pry
  # end

  def insert(dimensions, arg)
    raise "Invalid dimensions #{dimensions.length} expecting #{self.dimensions}" unless dimensions.length.eql?(self.dimensions)
    dimension = dimensions[self.mod]
    self.size += 1

    if ! self.dimension || self.dimension == dimension
      self.dimension = dimension
      dimensions.delete_at(self.mod)
      if dimensions.any?
        self.center.insert(dimensions, arg)
      else
        self.value = arg
        return self
      end
    elsif dimension < self.dimension
      self.left.insert(dimensions, arg)
    elsif dimension > self.dimension
      self.right.insert(dimensions, arg)
    end
  end

  def center
    @center ||= KDTree.new(self.dimensions - 1, 0, self)
  end

  def left
    @left ||= KDTree.new(self.dimensions, self.mod.succ % self.dimensions, self)
  end

  def right
    @right ||= KDTree.new(self.dimensions, self.mod.succ % self.dimensions, self)
  end
end

# tree = KDTree.new(1)
# # pairs = 10_000.times.map{|i|i}.shuffle.each_cons(7).to_a
# # pairs.each_with_index{|slc, i| tree[*slc] = slc }
# tree[0] = :a
# tree[1] = :b
# binding.pry
# tree.nearest(5)

# puts 1
# tree.nearest(1,3)
# tree.range_query(0..100, 7..43) do |v| puts "In: #{v}" end



# def solution(values)
#   tree = KDTree.new(2)
#   values.each.with_index do |value, index|
#     tree.insert(value, index)
#   end
# end

# values = [1, 11, 5, 8, 7, 10, 3, 9, 6, 4, 2, 15, 13, 12, 16, 17, 14]
# solution(values)