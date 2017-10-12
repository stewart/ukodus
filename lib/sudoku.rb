require_relative './problems'

class Sudoku
  attr_reader :rows

  DIGITS = (1..9).to_a.freeze

  def self.all
    PROBLEMS.map do |problem|
      new problem
    end
  end

  def self.first
    all.first
  end

  def initialize(rows)
    @rows = rows.map(&:freeze).freeze
  end

  def columns
    @rows[0].zip(*@rows[1..9])
  end

  def at(column, row)
    @rows.fetch(row).fetch(column)
  end

  def count
    rows.flatten.compact.count
  end

  def score
    81 - count
  end

  def row(n)
    rows[n]
  end

  def column(n)
    rows.map do |row|
      row[n]
    end
  end
  alias_method :col, :column

  def box(column, row)
    column /= 3
    row /= 3

    rows[row*3..row*3+2].flat_map do |r|
      r[column*3..column*3+2]
    end
  end

  def valid?
    rows.all? { |row| row.compact.length == row.uniq.compact.length } &&
    columns.all? { |column| column.compact.length == column.uniq.compact.length } &&
    boxes.all? { |box| box.compact.length == box.uniq.compact.length }
  end

  def possiblities_for(column, row)
    return [at(column, row)] if at(column, row)
    DIGITS -
      self.column(column) -
      self.row(row) -
      self.box(column, row)
  end

  def set(column, row, value)
    before = rows[0...row]
    after = rows[(row+1)...9]
    row = self.row(row).dup
    row[column] = value
    self.class.new [*before, row, *after]
  end

  def each_missing
    return enum_for(__method__) unless block_given?

    (0...9).each do |r|
      (0...9).each do |c|
        next if at(c, r)
        yield c, r
      end
    end
  end

  def remove(column, row)
    set(column, row, nil)
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
    "#<Sudoku:%x score:%d \n%s>" % [object_id, score, to_s]
  end
end
