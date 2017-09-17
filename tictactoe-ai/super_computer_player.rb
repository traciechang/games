require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    node = TicTacToeNode.new(game.board, mark)
    possible_moves = node.children
    a_winning_move = possible_moves.find { |move| move.winning_node?(mark) }
    return a_winning_move.prev_move_pos if a_winning_move
    non_losing_move = possible_moves.find { |move| !move.losing_node?(mark) }
    return non_losing_move.prev_move_pos if non_losing_move
    raise "No moves available"
  end
end

# class SuperComputerPlayer < ComputerPlayer
#   def move(game, mark)
#     node = TicTacToeNode.new(game.board, mark)
#     node.children.each do |child|
#       if child.winning_node?(mark)
#         return child.prev_move_pos
#       end
      
#       if !child.losing_node?(mark)
#         return child.prev_move_pos
#       end
#     end
#     raise "No moves available"
#   end
# end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Tyrion")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end