require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'
require 'byebug'

class Game
  attr_accessor :board, :player_one, :player_two, :current_player

  def initialize(player_one = HumanPlayer.new, player_two = ComputerPlayer.new)
    @player_one = player_one
    @player_two = player_two
    @board = Board.new
    @current_player = player_one
    @other_player = player_two
  end

  def switch_players!
    if @current_player == player_one
      @current_player = player_two
      @other_player = player_one
    else
      @current_player = player_one
      @other_player = player_two
    end
  end

  def play_turn
    player_one.display(@board)
    player_two.display(@board)
    @board.place_mark(@current_player.get_move, @current_player.mark)
    switch_players!
  end

  def play
    until @board.over?
      play_turn
    end
  end
end

if $PROGRAM_NAME == __FILE__
  puts "Enter name"
  name = gets.chomp.strip
  human = HumanPlayer.new(name)
  computer = ComputerPlayer.new("garry")
  new_game = Game.new(human, computer)
  new_game.play
end
