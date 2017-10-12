require 'pmap'

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
      if current.possibilities_for(col, row).count == 1
        best = current
      end
    end
    best
  end
end

class RandomRowsFirstReducer < SimpleReducer
  def each_position
    (0...9).to_a.shuffle.flat_map do |row|
      (0...9).to_a.shuffle.map do |col|
        [row, col]
      end
    end
  end
end

class RandomColsFirstReducer < SimpleReducer
  def each_position
    (0...9).to_a.shuffle.map do |col|
      (0...9).to_a.shuffle.flat_map do |row|
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

class BruteReducer < BaseReducer
  def reduce
    best = @sudoku
    best.each_filled.to_a.shuffle.each do |col, row|
      attempt = best.remove(col, row)
      if attempt.solve.solved?
        best = attempt
      end
    end
    best
  end
end

class Reducer < BaseReducer
  RANDOM_PASSES = ENV['ITERATIONS'] ? ENV['ITERATIONS'].to_i : 1000

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
    RANDOM_PASSES.times.map { BruteReducer.new(@sudoku) }.pmap(&:reduce)
  end
end
