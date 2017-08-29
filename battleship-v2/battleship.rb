require_relative "board"
require_relative "player"

class BattleshipGame
  attr_reader :player1, :player2, :current_player, :other_player

  def initialize(player1, player2)
      @player1 = player1
      @player2 = player2
      @current_player = player1
      @other_player = player2
  end

  def attack(move, board)
    board[move] = :x
  end
  
  def update_player_view_board(move, board, display_board)
    if board.in_range?(move)
      display_board[move] = :s
    else
      display_board[move] = :x
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
  
  def switch_players
    if current_player == player1
      @current_player = player2
      @other_player = player1
    else
      @current_player = player1
      @other_player = player2
    end
  end
  
  def play
    player1.board.populate_grid
    player2.board.populate_grid
    until player1.board.won? || player2.board.won?
      current_player.display_board.display
      players_move = current_player.get_play
      if other_player.board.in_range?(players_move)
        puts "Hit"
      else
        puts "Miss"
      end
      update_player_view_board(players_move, other_player.board, current_player.display_board)
      attack(players_move, other_player.board)
      switch_players
    end
    if player1.board.won?
      puts "player1 won!"
    else
      puts "player2 won!"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Do you want to play against computer? (y/n)"
  if gets.chomp.strip == "y"
    puts "Enter your name:"
    name = gets.chomp.strip
    human = HumanPlayer.new(name)
    comp = ComputerPlayer.new
    BattleshipGame.new(human, comp).play
  else
    puts "Enter player1's name:"
    player1 = HumanPlayer.new(gets.chomp.strip)
    puts "Enter player2's name:"
    player2 = HumanPlayer.new(gets.chomp.strip)
    BattleshipGame.new(player1, player2).play
  end
end