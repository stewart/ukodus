class Reducer
  def initialize(sudoku)
    @sudoku = sudoku
  end

  def reduce_once
    best = @sudoku
    (0...9).each do |row|
      (0...9).each do |col|
        current = best.remove(col, row)
        if current.possiblities_for(col, row).count == 1
          best = current
        end
      end
    end
    best
  end
end
