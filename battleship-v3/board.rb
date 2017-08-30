require 'byebug'

class Board
  attr_reader :grid

  def initialize(grid = Board.default_grid)
    @grid = grid
  end

  def self.default_grid
    Array.new(10) { Array.new(10) }
  end

  # def count
  #   grid.flatten.select { |space| space == :s }.length
  # end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end

  # def empty?(pos = nil)
  #   if pos
  #     return true if self[pos] == nil
  #     return false if self[pos] == :s
  #   else
  #     if grid.flatten.include? :s
  #       false
  #     else
  #       true
  #     end
  #   end
  # end

  def full?
    grid.flatten.none?(&:nil?)
  end

  def place_random_ship(ship_size)
    empty_spaces = []
    if full?
      raise "Board is full"
    else
      grid.each_with_index do |el, idx|
        el.each_with_index do |space, i|
          break if i == el.length - ship_size - 1
          ship_space_hor = []
          (0...ship_size).each do |num|
            ship_space_hor << [idx, i+num] if self[[idx, i+num]] == nil
          end
          empty_spaces << ship_space_hor
        end
        el.each_with_index do |space, i|
          # debugger if idx == grid.length - ship_size - 1
          break if idx >= grid.length - ship_size - 1
          ship_space_ver = []
          (0...ship_size).each do |num|
            # debugger
            ship_space_ver << [idx+num, i] if self[[idx+num, i]] == nil
          end
          empty_spaces << ship_space_ver
        end
      end
      empty_spaces.sample.each do |pos|
        self[pos] == :s
      end
      display
      #debugger
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

  def populate_grid(ships)
    ships.each do |ship|
      place_random_ship(ship.size)
    end
  end

  def in_range?(pos)
    self[pos] == :s
  end
end

class Ship
  attr_reader :size
  
  def initialize(size)
    @size = size
  end
end