

# a = 1
# b = 2 + a - count_impossible(a, b)
# c = 3 + b - count_impossible(b, c)
# d = 4 + c - count_impossible(c, d)
# e = 5 + d - count_impossible(d, e)

01
# 1 available
# -1 selected => 0
# {
#   0 => 1,
#   add: {
#     0 => 0,
#     default => -1
#   }
# }

010

# 2 available
# -1 selected => 1
# {
#   0 => 1,
#   1 => 1,
#   add: {
#     0 => -1,
#     1 => -1,
#     default => -2
#   }
# }

0100
# 3 available
# -1 selected => 2
# {
#   0 => 2,
#   1 => 1,
#   add: {
#     0 => -1,
#.    1 => -2,
#     default => -3
#   }
# }

01001
# 4 available
# -1 selected => 3
# {
#   0 => 2
#   1 => 2,
#   add: {
#     0 => -1,
#     1 => -1,
#     default = -4
#   }
# }


Rules:
  Select number of impossibilities to substract
  Next impossibilities are calculated as follows:
    If default is selected, this value is subtracted from all
    Default is added to subsequent table at 1 + default
