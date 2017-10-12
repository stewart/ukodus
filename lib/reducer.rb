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
    (0...9).to_a.shuffle.flat_map do |row|
      (0...9).to_a.shuffle.map do |col|
        [row, col]
      end
    end
  end
end

class RowReducer < SimpleReducer
  def initialize(sudoku, row)
    @sudoku = sudoku
    @row = row
  end

  def each_position
    (0...9).flat_map do |row|
      (0...9).map do |col|
        [row, col]
      end
    end.sort_by do |position|
      position.first == @row ? 0 : 1
    end
  end
end

class ColumnReducer < SimpleReducer
  def initialize(sudoku, column)
    @sudoku = sudoku
    @column = column
  end

  def each_position
    (0...9).flat_map do |row|
      (0...9).map do |col|
        [row, col]
      end
    end.sort_by do |position|
      position.last == @column ? 0 : 1
    end
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
      (0...9).map { |row| RowReducer.new(@sudoku, row).reduce },
      (0...9).map { |col| ColumnReducer.new(@sudoku, col).reduce }
    ].flatten
  end
end
