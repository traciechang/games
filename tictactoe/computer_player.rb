require 'byebug'

class ComputerPlayer
  attr_accessor :name, :mark, :board

  def initialize(name)
    @name = name
    @mark = :O
    @board = []
  end

  def display(board)
    @board = board
  end

  def get_move
    if can_col_win != nil
      board.grid.each_with_index do |row, row_idx|
        row.each_with_index do |pos, pos_idx|
          if pos_idx == can_col_win
            return [row_idx, pos_idx] if pos == nil
          end
        end
      end
    end

    if can_row_win != nil
      board.grid.each_with_index do |row, row_idx|
        row.each_with_index do |pos, pos_idx|
          if row_idx == can_row_win
            return [row_idx, pos_idx] if pos == nil
          end
        end
      end
    end

    if can_col_win == nil || can_row_win == nil
      available_spaces = []
      board.grid.each_with_index do |row, row_idx|
        row.each_with_index do |pos, pos_idx|
          available_spaces << [row_idx, pos_idx] if pos == nil
        end
      end
      available_spaces.sample
    end

  end


  def can_row_win
    left_pos = {}

     board.grid.each_with_index do |row, row_idx|
      row.each_with_index do |pos, pos_idx|
        if pos == mark
          if left_pos.has_key? row_idx
            left_pos[row_idx] += 1
          else
            left_pos[row_idx] = 1
          end
        end
      end
    end

    return left_pos.key(2) if left_pos.has_value?(2)
  end

  def can_col_win
    right_pos = {}

     board.grid.each_with_index do |row, row_idx|
      row.each_with_index do |pos, pos_idx|
        if pos == mark
          if right_pos.has_key? pos_idx
            right_pos[pos_idx] += 1
          else
            right_pos[pos_idx] = 1
          end
        end
      end
    end

    return right_pos.key(2) if right_pos.has_value?(2)
  end

end
