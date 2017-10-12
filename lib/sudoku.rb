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

  def at(column, row)
    @rows.fetch(row).fetch(column)
  end

  def valid?
    rows.all? { |row| row.compact.length == row.uniq.compact.length } &&
    columns.all? { |column| column.compact.length == column.uniq.compact.length }
  end

  def remove(column, row)
    cloned_rows = Marshal.load(Marshal.dump(@rows))
    cloned_rows[row][column] = nil
    Sudoku.new cloned_rows
  end
end
