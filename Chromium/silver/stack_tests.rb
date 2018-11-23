require 'pry-byebug'

# switches.each do |level|
#   levels = level - last_height
#   next if levels.zero?
#   if path == 1
#     increase = left * levels
#     path = 0
#     total += increase
#     right += increase
#   else
#     increase = right * levels
#     path = 1
#     total += increase
#     left += increase
#   end
#   last_height = level
# end
# levels = max - switches[-1]
# total += (path == 1 ? left : right) * levels


def build_default_proc(_left, _right, _total, _path, _last_height)
  ->(h, level) do
    left, right, total, path, last_height = _left, _right, _total, _path, _last_height
    levels = level - last_height
    if path == 1
      increase = left * levels
      path = 0
      total += increase
      right += increase
    else
      increase = right * levels
      path = 1
      total += increase
      left += increase
    end
    last_height = level
    nested = {
      left: left,
      right: right,
      total: total,
      path: path,
      next: nested
    }
    nested.default_proc = build_default_proc(left, right, total, path, last_height)


    h[level] = nested
  end
end

$tree = {}
$tree.default_proc = build_default_proc(1, 1, 1, 0, 0, -1)


binding.pry

def calculate(min, start, max, stack)
  4
end

def test()
end


test([1,5,8], 1, 10) #52
test([1,5,8], 1, 8) # 20
test([7,9,14], 3, 15) # 130
test([7,9,14], 1, 15) # 178
test([7,9,14], 1, 19) #506
test([0,4,8], 0, 8) # 25
test([0,1,2], 0, 2) # 4
