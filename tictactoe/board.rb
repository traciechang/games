class Board
  attr_reader :grid

  def initialize(grid = Array.new(3) { Array.new(3) })
    @grid = grid
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end

  def place_mark(pos, mark)
    if empty?(pos)
      self[pos] = mark
    else
      raise "Space taken"
    end
  end

  def empty?(pos)
    self[pos] == nil
  end

  def winner
    x_positions = []
    o_positions = []

    grid.each_with_index do |row, row_idx|
      row.each_with_index do |pos, pos_idx|
        x_positions << [row_idx, pos_idx] if row[pos_idx] == :X
        o_positions << [row_idx, pos_idx] if row[pos_idx] == :O
      end
    end

    return :X if diagonals?(x_positions) || rows_n_columns?(x_positions)
    return :O if diagonals?(o_positions) || rows_n_columns?(o_positions)
  end

  def rows_n_columns?(positions)
    row_hash = {}
    col_hash = {}

    positions.each do |pos|
      if row_hash.include?(pos[0])
        row_hash[pos[0]] += 1
      else
        row_hash[pos[0]] = 1
      end

      if col_hash.include?(pos[1])
        col_hash[pos[1]] += 1
      else
        col_hash[pos[1]] = 1
      end
    end
    row_hash.values.include?(3) || col_hash.values.include?(3)
  end

  def diagonals?(positions)
    left_count = 0
    right_count = 0

    if positions.length > 2
      positions.each do |pos|
        left_count += 1 if [[0, 0], [1, 1], [2, 2]].include? pos
        right_count += 1 if [[0, 2], [1, 1], [2, 0]].include? pos
      end
    end
    left_count == 3 || right_count == 3
  end

  def over?
    winner || cats?
  end

  def cats?
    # look into Array#all? #any? #none? #flatten
    grid.flatten.none? { |space| space.nil? }
  end
end

