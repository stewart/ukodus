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

class RandomReducer < SimpleReducer
  ALL_POSITIONS = (0...9).to_a.flat_map do |row|
    (0...9).to_a.map do |col|
      [row, col]
    end
  end.freeze

  def each_position
    ALL_POSITIONS.shuffle
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
    select_best passes: RANDOM_PASSES do
      current = select_best(passes: 100) { RandomReducer.new(@sudoku).reduce }
      BruteReducer.new(current).reduce
    end
  end

  def select_best(passes: 10)
    best = yield
    (passes - 1).times do
      attempt = yield
      if attempt.score > best.score
        best = attempt
      end
    end
    best
  end
end
