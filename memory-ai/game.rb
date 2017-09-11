require_relative 'player'
require_relative 'board'
require_relative 'computer_player'
require 'byebug'

class Game
    attr_reader :player, :board
    
    def initialize(player:, board:)
        @player = player
        @board = board
    end
    
    def is_match?(guess1, guess2)
        guess1 == guess2
    end
    
    def play
        board.create_cards
        board.populate
        player.get_all_spaces
        
        until board.won?
            guess = player.get_guess
            #debugger
            if guess.all? { |el| el.is_a?(Array) }
                guess2 = guess[1]
                guess = guess[0]
            else
                guess2 = player.get_guess
            end
            #debugger
            board[guess].reveal
            player.receive_revealed_card(guess: guess, val: board[guess].face_value)
            board[guess2].reveal
            player.receive_revealed_card(guess: guess2, val: board[guess2].face_value)
            board.display
            puts "**************************************"
            
            if !is_match?(board[guess].face_value, board[guess2].face_value)
                sleep(2)
                system("clear")
                board[guess].hide
                board[guess2].hide
                board.display
                puts "************************************"
            elsif is_match?(board[guess].face_value, board[guess2].face_value)
                player.receive_match(guess, guess2)
            end
        end
        puts "You win!"
    end
end

if __FILE__ == $PROGRAM_NAME
    bran = ComputerPlayer.new(name: "bran")
    brans_board = Board.new
    Game.new(player: bran, board: brans_board).play
end