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
    cloned_rows = rows.map(&:dup)
    cloned_rows[row][column] = nil
    self.class.new cloned_rows
  end

  def boxes
    [0..2, 3..5, 6..8].flat_map do |rs|
      [0..2, 3..5, 6..8].map do |cs|
        rows[rs].flat_map do |row|
          row[cs]
        end
      end
    end
  end

  def to_s
    divider = "+-------+-------+-------+\n"

    divider + rows.map do |row|
      row.map do |val|
        val.nil?? " " : val.to_s
      end.each_slice(3).map do |x|
        x.join(" ")
      end.join(" | ")
    end.map do |row|
      "| #{row} |\n"
    end.each_slice(3).map do |x|
      x.join
    end.join(divider) + divider
  end

  def inspect
    "#<Sudoku:%x \n%s>" % [object_id, to_s]
  end
end
