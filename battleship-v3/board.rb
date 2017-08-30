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

  attr_reader :grid, :ships, :count_ships

  def initialize(grid = self.class.default_grid, random = false)
    @grid = grid
    @ships = {
      aircraft = Ship.new(5) => [aircraft.size, []],
      battleship = Ship.new(4) => [battleship.size, []],
      submarine = Ship.new(3) => [submarine.size, []],
      destroyer = Ship.new(3) => [destroyer.size, []],
      patrol = Ship.new(2) => [patrol.size, []]
      
    }
    ships.each { |name, size| randomize(name, size[0]) } if random
    @count_ships = ships.length
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
    ships.each do |name, size|
      @count_ships -= 1 if size[1].all? { |space| space == :x }
    end
    count_ships
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

  def place_random_ship(name, ship_size)
    raise "hell" if full?
    two_ships = random_pos(ship_size)
    hor_ship = two_ships[0]
    ver_ship = two_ships[1]

    until hor_ship.all? { |space| empty?(space) } || ver_ship.all? { |space| empty?(space) }
      two_ships = random_pos(ship_size)
      hor_ship = two_ships[0]
      ver_ship = two_ships[1]
    end
    
    if hor_ship.all? { |space|  empty?(space) }
      hor_ship.each do |space|
        self[space] = :s
        ships[name][1] << space 
      end
    else
      ver_ship.each do |space|
        self[space] = :s
        ships[name][1] << space
      end
    end
  end

  def randomize(name, ship_size)
    place_random_ship(name, ship_size)
  end

  def random_pos(ship_size)
    rand_row = rand(size)
    rand_col = rand(size)
    hor_ship = []
    ver_ship = []
    
    (0...ship_size).each do |num|
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
