require_relative 'player'
require 'byebug'

class Game
    attr_reader :player1, :player2, :current_player, :previous_player, :fragment, :dictionary, :status, :losses, :mod_dictionary
    
    def initialize(player1:, player2:, dictionary:)
        @player1 = player1
        @player2 = player2
        @current_player = player1
        @previous_player = player2
        @fragment = []
        @dictionary = dictionary
        @mod_dictionary = []
        dictionary.each { |word| @mod_dictionary << word }
        @status = true
        @losses = {
            player1 => -1,
            player2 => -1
        }
    end
    
    def display_standings(player)
        standing = ""
        (0..losses[player]).each { |num| standing += "GHOST"[num] }
        puts standing
    end
    
    def play_round
        until !status
            display_standings(current_player)
            take_turn(current_player)
            next_player!
        end
        record(previous_player)
    end
    
    def next_player!
        if current_player == player1
            @current_player = player2
            @previous_player = player1
        else
            @current_player = player1
            @previous_player = player2
        end
    end
    
    def record(player)
        losses[player] += 1
    end
    
    def run
        until (losses[player1] == 4) || (losses[player2] == 4)
            @fragment = []
            @status = true
            @mod_dictionary = []
            dictionary.each { |word| @mod_dictionary << word }
            play_round
        end
    end
    
    def take_turn(player)
        guessed_letter = player.guess
        position = find_position
        
        until valid_letter?(guessed_letter)
            player.alert_invalid_guess
            guessed_letter = player.guess
        end
        
        filter_dictionary(guessed_letter, position)

        if valid_play?(guessed_letter)
            @fragment << guessed_letter
            puts "That works!"
        else
            puts "You lose!"
            @status = false
        end
    end
    
    def valid_letter?(string)
        ("a".."z").include?(string)
    end
    
    def valid_play?(string)
        temp_fragment = "#{fragment.join}#{string}"
        !mod_dictionary.include?(temp_fragment) && !(mod_dictionary.empty?)
    end
    
    def filter_dictionary(string, position)
        @mod_dictionary = mod_dictionary.select do |word|
            word.split("")[position] == string
        end
    end
    
    def find_position
        fragment.length
    end
end

if __FILE__ == $PROGRAM_NAME
    arya = Player.new(name: "arya")
    sansa = Player.new(name: "sansa")
    my_dictionary = File.readlines("dictionary.txt").map(&:chomp)
    Game.new(player1: arya, player2: sansa, dictionary: my_dictionary).run
end