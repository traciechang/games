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
    print "
      #{grid[0]}
      #{grid[1]}
      #{grid[2]}
      #{grid[3]}
      #{grid[4]}
      #{grid[5]}
      #{grid[6]}
      #{grid[7]}
      #{grid[8]}
      #{grid[9]}
      #{grid[10]}
    "
  end

  def populate_grid
    5.times { place_random_ship }
  end

  def in_range?(pos)
    self[pos] == :s
  end
end
