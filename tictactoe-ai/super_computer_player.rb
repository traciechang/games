require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    node = TicTacToeNode.new(game.board, mark)
    node.children.each do |el|
      node.create_child_node(el)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Tyrion")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
