require 'byebug'

class Board
  attr_reader :grid

  def initialize(grid = Board.default_grid)
    @grid = grid
  end

  def self.default_grid
    Array.new(10) { Array.new(10) }
  end

  def count
    grid.flatten.select { |space| space == :s }.length
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end

  def empty?(pos = nil)
    if pos
      return true if self[pos] == nil
      return false if self[pos] == :s
    else
      if grid.flatten.include? :s
        false
      else
        true
      end
    end
  end

  def full?
    grid.flatten.none?(&:nil?)
  end

  def place_random_ship
    empty_spaces = []
    if full?
      raise "Board is full"
    else
      grid.each_with_index do |el, idx|
        el.each_with_index do |space, i|
          empty_spaces << [idx, i] if space == nil
        end
      end
      self[empty_spaces.sample] = :s
    end
  end

  def won?
    grid.flatten.none? { |pos| pos == :s}
  end

  def display
  end

  def populate_grid
  end

  def in_range?(pos)
  end
end
