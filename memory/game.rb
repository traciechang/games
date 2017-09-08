require_relative 'player'
require_relative 'board'
require 'byebug'

class Game
    attr_reader :player, :board, :last_guess
    
    def initialize(player:, board:)
        @player = player
        @board = board
        @last_guess = []
    end
    
    def is_match?(guess1, guess2)
        guess1 == guess2
    end
    
    def play
        board.create_cards
        board.populate
        
        until board.won?
            guess = player.get_guess
            @last_guess = guess
            board[guess].reveal
            guess2 = player.get_guess
            board[guess2].reveal
            board.display
            
            if !is_match?(board[guess].face_value, board[guess2].face_value)
                sleep(5)
                system("clear")
                board[guess].hide
                board[guess2].hide
                board.display
            end
        end
        puts "You win!"
    end
    
end

if __FILE__ == $PROGRAM_NAME
    bran = Player.new(name: "bran")
    brans_board = Board.new
    Game.new(player: bran, board: brans_board).play
end