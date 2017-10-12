class BaseReducer
  def initialize(sudoku)
    @sudoku = sudoku
  end
end

class SimpleReducer < BaseReducer
  def reduce
    best = @sudoku
    each_position.each do |row, col|
      current = best.remove(col, row)
      if current.possiblities_for(col, row).count == 1
        best = current
      end
    end
    best
  end
end

class RandomReducer < SimpleReducer
  def each_position
    (0...9).flat_map do |row|
      (0...9).map do |col|
        [row, col]
      end
    end.shuffle
  end
end

class Reducer < BaseReducer
  def reduce
    best = @sudoku
    100.times do
      current = RandomReducer.new(@sudoku).reduce
      if current.score > best.score
        best = current
      end
    end
    best
  end
end
