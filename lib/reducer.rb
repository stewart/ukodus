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

class RowReducer < SimpleReducer
  def initialize(sudoku, row)
    @sudoku = sudoku
    @row = row
  end

  # FIXME this isn't right
  def each_position
    (0...9).flat_map do |row|
      (0...9).map do |col|
        [row, col]
      end
    end.reverse
  end
end

class Reducer < BaseReducer
  def reduce
    best = @sudoku

    solutions.each do |solution|
      if solution.score > best.score
        best = solution
      end
    end

    best
  end

  private

  def solutions
    [
      100.times.map { RandomReducer.new(@sudoku).reduce },
      (0...9).map { |row| RowReducer.new(@sudoku, row).reduce }
    ].flatten
  end
end
