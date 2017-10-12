class Solver
  def initialize(sudoku)
    @initial = sudoku
  end

  def solve
    best = @initial
    loop do
      current = fill_in_known(best)
      if current.count > best.count
        best = current
      else
        break
      end
    end
    best
  end

  def fill_in_known(sudoku)
    sudoku.each_missing do |col, row|
      possibilities = sudoku.possibilities_for(col, row)

      if possibilities.count == 1
        sudoku = sudoku.set(col, row, possibilities[0])
      end
    end
    sudoku
  end
end
