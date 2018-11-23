require 'matrix'
require 'pry-byebug'
def get_matrix(args)
  return Matrix[[1,0],[0,1]] unless args.any?
  $tree ||= {}
  *rest, tail  = args
  $tree[args] ||= get_matrix(rest) * Matrix[[0,1],[1, tail]]
end

rnd = 2_000.times.map{|i| i}.shuffle
get_matrix(rnd)
# binding.pry
# puts 3