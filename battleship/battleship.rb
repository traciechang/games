class BattleshipGame
  attr_reader :board, :player

  def initialize(player, board)
      @player = player
      @board = board
  end

  def attack(move)
    board[move] = :x
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
end
