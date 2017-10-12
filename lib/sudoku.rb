require 'problems'

class Sudoku
  attr_reader :rows

  def self.first
    new PROBLEMS.first
  end

  def initialize(rows)
    @rows = rows
  end

  def columns
    @rows[0].zip(*@rows[1..9])
  end
end
