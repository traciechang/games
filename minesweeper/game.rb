require_relative 'board'
require_relative 'player'
require 'byebug'

class Game
    attr_reader :board, :player
    
    def initialize
        @board = Board.new
        @player = Player.new(name: "cersei")
    end
    
    def explode?(pos)
        board[pos].value == :b && board[pos].revealed
    end
    
    def play
        board.seed
        register_bombs
        board.display
        pos = player.get_position
        move = player.get_move
        register_move(pos, move)
        
        until explode?(pos) || won?
            board.display
            pos = player.get_position
            move = player.get_move
            register_move(pos, move)
        end
        
        puts "You lose!" if explode?(pos)
        puts "You win!" if won?
    end
    
    def won?
        spaces_without_bomb = board.grid.flatten.select { |space| space != :b }
        spaces_without_bomb.all? { |space| space.revealed }
    end

    def register_bombs
        board.grid.flatten.each do |tile|
            neighboring_bombs = tile.neighbor_bomb_count
            tile.value = neighboring_bombs if (tile.value != :b) #&& (neighboring_bombs != 0))
        end
    end
    
    def register_move(pos, move)
        if move == "r"
            board[pos].revealed = true
        elsif move == "f"
            !board[pos].flagged ? board[pos].flagged = true : board[pos].flagged = false
        end
    end
    

end

Game.new.play