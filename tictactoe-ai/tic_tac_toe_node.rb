require_relative 'tic_tac_toe'
require 'byebug'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos
  
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    opp_of_evaluator = (evaluator == :x) ? :o : :x
    if board.over?
      return board.won? && (board.winner == opp_of_evaluator)
    end

    if next_mover_mark == evaluator
      children.all? { |child| child.losing_node?(evaluator) }
    else
      children.any? { |child| child.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    if board.over?
      return board.won? && board.winner == evaluator
    end
    
    if next_mover_mark == evaluator
      children.any? { |child| child.winning_node?(evaluator) }
    else
      children.all? { |child| child.winning_node?(evaluator) }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    child_nodes = []
    child_mark = switch_next_mover_mark
    potential_moves = get_potential_moves
    potential_moves.each do |move|
      child_nodes << TicTacToeNode.new(create_child_node(move), child_mark, move)
    end
    child_nodes
  end
  
  def create_child_node(pos)
    dup_board = board.dup
    dup_board[pos] = next_mover_mark
    dup_board
  end
  
  def get_potential_moves
    potential_moves = []
    (0..2).each do |row|
      (0..2).each do |col|
        potential_moves << [row, col] if board[[row, col]].nil?
      end
    end
    potential_moves
  end
  
  def switch_next_mover_mark
    (next_mover_mark == :x) ? :o : :x
  end
end