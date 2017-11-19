class Piece
  attr_reader :left, :right, :height, :type, :points

  def initialize(left, right, height, type)
    @left   = left
    @right  = right
    @height = height
    @type = type
    @points = @type == 'p' ? 1 : 10
  end

  def to_s
    "#{@type}@#{@height}:(#{@left} - #{@right})"
  end
end

def solution(xs, ys, types)
  rights    = Hash.new{|h,k| h[k] = []}
  lefts     = Hash.new{|h,k| h[k] = []}
  start_idx = types.index(?X)
  start     = Piece.new(0, 0, 0, ?X)
  x_offset  = xs[start_idx]
  y_offset  = ys[start_idx]

  best = Hash.new(0)
  pieces = xs.zip(ys, types.chars).map do |x, y, t|
    next if t == ?X
    steps = y - y_offset
    x_pos = x - x_offset
    Piece.new( x_pos + steps,  x_pos - steps, steps, t)
  end.compact.sort_by(&:height).reverse.each do |piece|
    rights[piece.right] << piece
    lefts[piece.left]  << piece
  end

  next_lefts  = lefts[0][-1] ? [{to: lefts[0][-1],  from: [0, 0, :left]}] : []
  next_rights = rights[0][-1] ? [{to: rights[0][-1], from: [0, 0, :right]}] : []

  steps       = []
  puts next_lefts.any?
  puts next_rights.any?

  while next_lefts.any? || next_rights.any?
    next_step_lefts  = []
    next_step_rights = []

    next_lefts.each do |step|
      to = step[:to]
      from = step[:from]
      lefts[to.left].pop
      puts "Stepping left over #{to.height}-#{to.left}"
      if lefts[to.left].any? && lefts[to.left].first.height == to.height.succ
        puts "Skipping - can't make this move"
        next
      end
      if best[[to.height, to.left, :left]] < best[from] + to.points
        best[[to.height, to.left, :left]] = best[from] + to.points
        next_step_lefts << {
          to: lefts[step[:to].left].last,
          from: [
            to.height,
            to.left,
            :left
          ]
        } if lefts[step[:to].left].any?

        max_right = lefts[step[:to].left].any? ? lefts[step[:to].left].last.right : Float::INFINITY
        rights.each do |position, (piece)|
          if piece && position > step[:to].right && position < max_right
            next_step_rights << {
              to: piece,
              from: [
                to.height,
                to.left,
                :left
              ]
            }
          end
        end
      end
    end

    next_rights.each do |step|
      to = step[:to]
      from = step[:from]
      rights[to.right].pop
      puts "Stepping right over #{to.height}-#{to.right}"
      if rights[to.right].any? && rights[to.right].first.height == to.height.succ
        puts "Skipping - can't make this move"
        next
      end

      if best[[to.height, to.right, :right]] < best[from] + to.points
        best[[to.height, to.right, :right]] = best[from] + to.points
        next_step_rights << {
          to: rights[to.right].last,
          from: [
              to.height,
              to.right,
              :right
            ]
        } if rights[to.right].any?

        max_left = rights[to.right].any? ? rights[to.right].last.left : Float::INFINITY
        lefts.each do |position, (piece)|
          if piece && position > to.left && position < max_left
            next_step_lefts << {
              to: piece,
              from: [
                from: [
                  to.height,
                  to.right,
                  :right
                ]
              ]
            }
          end
        end
      end
    end

    next_lefts  = next_step_lefts
    next_rights = next_step_rights
    puts 3
  end

  puts best
  # While we can step forwards
  # We can jump over
  return (best.values).max
end
