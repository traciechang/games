require 'byebug'
class Board
  DISPLAY_HASH = {
    nil => " ",
    :s => " ",
    :x => "x"
  }

  def self.default_grid
    Array.new(10) { Array.new(10) }
  end

  def self.random
    self.new(self.default_grid, true)
  end

  attr_reader :grid, :ships

  def initialize(grid = self.class.default_grid, random = false)
    @grid = grid
    @ships = [5, 4, 3, 3, 2]
    randomize if random
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    grid[row][col] = val
  end

  def count
    grid.flatten.select { |el| el == :s }.length
  end

  def display
    header = (0..9).to_a.join("  ")
    p "  #{header}"
    grid.each_with_index { |row, i| display_row(row, i) }
  end

  def display_row(row, i)
    chars = row.map { |el| DISPLAY_HASH[el] }.join("  ")
    p "#{i} #{chars}"
  end

  def empty?(pos = nil)
    if pos
      self[pos].nil?
    else
      count == 0
    end
  end

  def full?
    grid.flatten.none?(&:nil?)
  end

  def in_range?(pos)
    pos.all? { |x| x.between?(0, grid.length - 1) }
  end

  def place_random_ship
    raise "hell" if full?
    two_ships = random_pos
    hor_ship = two_ships[0]
    ver_ship = two_ships[1]

    until hor_ship.all? { |space| empty?(space) } || ver_ship.all? { |space| empty?(space) }
      two_ships = random_pos
      hor_ship = two_ships[0]
      ver_ship = two_ships[1]
    end
    
    if hor_ship.all? { |space|  empty?(space) }
      hor_ship.each { |space| self[space] = :s}
    else
      ver_ship.each { |space| self[space] = :s}
    end
  end

  def randomize(count = ships.length)
    count.times { place_random_ship }
  end

  def random_pos
    rand_row = rand(size)
    rand_col = rand(size)
    hor_ship = []
    ver_ship = []
    
    (0...ships.length).each do |num|
      hor_ship << [rand_row, rand_col + num]
      ver_ship << [rand_row + num, rand_col]
    end
    [hor_ship, ver_ship]
  end

  def size
    grid.length
  end

  def won?
    grid.flatten.none? { |el| el == :s }
  end
end
