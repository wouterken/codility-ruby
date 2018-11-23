03113
= 5 + ....

# a = 1
# b = 2 + a - count_impossible(a, b)
# c = 3 + b - count_impossible(b, c)
# d = 4 + c - count_impossible(c, d)
# e = 5 + d - count_impossible(d, e)

03
# 1 available
# -1 selected => 0
# {
#   0 => 1,
#   add: {
#     0 => 0,
#     ... => -1 (x)
#   }
# }

031

# 2 available
# -2 selected => 0
# {
#   0 => 1,
#   3 => 1,
#   add: {
#     0 => -1,
#     3 =>  0,
#     default => -2 (x)
#   }
# }

0311
# 3 available
# -2 selected => 1
# {
#   0 => 1,
#   3 => 1,
#   1 => 1,
#   add: {
#     0 => -3,
#.    1 => -1, (x)
#     3 => -2
#     default => -3
#   }
# }

03111
# 4 available
# -1 selected => 3
# {
#   0 => 2
#   1 => 2,
#   add: {
#     0 => -3,
#     1 => -2,
#     3 => -2
#     ... => -4
#   }
# }


031111
# 5 available
#
# {
#   add: {
#
#   }
# }
#
#