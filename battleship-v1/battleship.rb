require_relative "board"
require_relative "player"

class BattleshipGame
  attr_reader :board, :player, :player_view_board

  def initialize(player, board)
      @player = player
      @board = board
      @player_view_board = Board.new
  end

  def attack(move)
    board[move] = :x
  end
  
  def update_player_view_board(move)
    if board.in_range?(move)
      player_view_board[move] = :s
    else
      player_view_board[move] = :x
    end
  end

  def count
    board.count
  end

  def game_over?
    board.won?
  end

  def play_turn
    attack(player.get_play)
  end
  
  def play
    board.populate_grid
    until game_over?
      player_view_board.display
      players_move = player.get_play
      if board.in_range?(players_move)
        puts "Hit"
      else
        puts "Miss"
      end
      update_player_view_board(players_move)
      attack(players_move)
    end
    puts "You win!"
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Enter your name:"
  name = gets.chomp.strip
  human = HumanPlayer.new(name)
  BattleshipGame.new(human, Board.new).play
end