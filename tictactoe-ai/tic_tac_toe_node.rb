require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos
  
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    evaluator.over? && evaluator.winner == :x
  end

  def winning_node?(evaluator)
    evaluator.over? && evaluator.winner == :o
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    potential_moves = []
    (0..2).each do |row|
      (0..2).each do |col|
        potential_moves << [row, col] if board[[row, col]].empty?
      end
    end
    potential_moves
  end
  
  def create_child_node(pos)
    dup_board = deep_dup(board)
    dup_board[pos] = next_mover_mark
    dup_board
  end
  
  def deep_dup(array)
    return array unless obj.is_a?(Array)
    array.map { |el| deep_dup(el) }
  end
  
  def switch_next_mover_mark
    @next_mover_mark = (next_mover_mark == :x) ? :o : :x
  end
end

# def some_method
#   potential_moves = children
#   potential_moves.each do |move|
#     create_child_node(move)
#   end
# end

create_child_node(move)
TicTacToeNode.new(create_child_node(move), next_mover_mark) # need to switch next_move_mark somehwere