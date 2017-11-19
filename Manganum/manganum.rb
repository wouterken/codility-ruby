require 'pry-byebug'
X    = 0
Y    = 1
TYPE = 2

QUEEN = ?q
PAWN  = ?p

class Array
  def bs_idx
    low = 0; high = length - 1
    until low > high
      mid = low + ((high - low) / 2)
      cmp = yield self[mid]
      if cmp == 1
        high = mid - 1
      elsif cmp == -1
        low = mid + 1
      elsif cmp == 0
        return mid
      end
    end
    return low
  end
end

def get_left_root((x,y))
  x - y
end

def get_right_root((x,y))
  x + y
end

def score((x,y,t))
  t == QUEEN ? 10 : 1
end

def best_move(piece, par, per)

end

def solution(xs, ys, types)
  occupied_spaces = {}
  ((*,player), board) = xs.zip(ys.map{|y| y - 1}, types.chars).sort_by{|piece| piece[Y]}.slice_when{|x| x[TYPE] == 'X'}.to_a
  board.each do |(x,y)|
    occupied_spaces[[x,y]] = true
  end
  last_piece  = board[-1]
  lines_left  = [] #Hash.new{|h,k| h[k] = []}
  lines_right = [] #Hash.new{|h,k| h[k] = []}

  board.reverse_each do |at_piece|
    next_right     = [at_piece[X] + 1, at_piece[Y] + 1] # Where we end up if we jump to the right by 1
    next_left      = [at_piece[X] - 1, at_piece[Y] + 1] # Where we end up if we jump to the left by 1
    previous_right = [at_piece[X] + 1, at_piece[Y] - 1] # Where we end up if we jump to the right by 1
    previous_left  = [at_piece[X] - 1, at_piece[Y] - 1] # Where we end up if we jump to the left by 1

    left_root  = get_left_root  at_piece
    right_root = get_right_root at_piece

    best_move_right = case
    when occupied_spaces[next_left] || occupied_spaces[previous_right] then 0
    else
      left_parent    = lines_right[right_root][-1]
      left_crossings = lines_left.select do |root, line|
        root < left_root && (
          !left_parent ||
          root > (right_root - 2 * left_parent[0])
        )
      end
      possibilities = ([left_parent] + left_crossings.map do |root, line|
        cross_height = at_piece[Y] + (left_root - root) / 2
        insert_index = line.bs_idx{|(height, score)| cross_height <=> height } - 1
        insert_index >= 0 ? line[insert_index] : nil
      end).compact.max_by(&:last)
      possibilities&.last.to_i + score(at_piece)
    end

    best_move_left = case
    when occupied_spaces[next_right] || occupied_spaces[previous_left] then 0
    else
      right_parent    = lines_left[left_root][-1]
      right_crossings = lines_right.select do |root, line|
        root > right_root && (
          !right_parent ||
          root < (left_root + 2 * right_parent[0])
        )
      end
      puts "Selected #{right_crossings.length} out of #{lines_right.size}"
      possibilities = ([right_parent] + right_crossings.map do |root, line|
        cross_height = at_piece[Y] + (root - right_root) / 2
        insert_index = line.bs_idx{|(height, score)| cross_height <=> height } - 1
        insert_index >= 0 ? line[insert_index] : nil
      end).compact.max_by(&:last)
      possibilities&.last.to_i + score(at_piece)
    end
    # binding.pry
    lines_right[right_root] << [at_piece[Y], best_move_right]
    lines_left[left_root] << [at_piece[Y], best_move_left]
  end
  # binding.pry
  #
  [
    (lines_left[player[X]][-1] || [0,0])[-1],
    (lines_right[player[X]][-1] || [0,0])[-1]
  ].max
end

def assert_correct(got, expected)
  if (got == expected)
    puts 'match'
  else
    puts "Expected #{expected} got #{got}"
  end
end

count = 10000
vals = count.times.map{|i| i}
assert_correct(solution([7] + vals.shuffle, [1] + vals.shuffle, 'X' + count.times.map{'p'}.join), 10)
assert_correct(solution([0, 3, 5, 1, 6],[4, 1, 3, 3, 8],"pXpqp"), 2)
assert_correct(solution([0, 6, 2, 5, 3, 0],[4, 8, 2, 3, 1, 6],"ppqpXp"), 12)

