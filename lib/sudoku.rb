require_relative './problems'

class Sudoku
  attr_reader :rows

  def self.all
    PROBLEMS.map do |problem|
      new problem
    end
  end

  def self.first
    all.first
  end

  def initialize(rows)
    @rows = rows
  end

  def columns
    @rows[0].zip(*@rows[1..9])
  end

  def remove(column, row)
    cloned_rows = Marshal.load(Marshal.dump(@rows))
    cloned_rows[row][column] = nil
    Sudoku.new cloned_rows
  end
end
