require_relative 'player'
require_relative 'ai_player'
require 'byebug'

class Game
    attr_reader :players, :current_player, :fragment, :dictionary, :status, :mod_dictionary
    
    def initialize(dictionary:)
        @players = []
        @current_player = nil
        @fragment = []
        @dictionary = dictionary
        @mod_dictionary = []
        dictionary.each { |word| @mod_dictionary << word }
        @status = true
    end
    
    def display_standings(player)
        standing = ""
        (0..player.losses).each { |num| standing += "GHOST"[num] }
        puts "#{player.name} has the following letters: #{standing}"
    end
    
    def exclude_player(player)
        players.delete(player)
    end
    
    def get_players
        puts "Do you want to add a player?(y/n)"
        answer = gets.chomp
        until answer == 'n'
            if answer == 'y'
                puts "Enter player name:"
                players << Player.new(name: gets.chomp.strip)
            else
                puts "Not a valid option."
            end
            puts "Do you want to add a player?(y/n)"
            answer = gets.chomp
        end
        @current_player = players[0]
    end
    
    def play_round
        until !status
            take_turn(current_player)
            exclude_player(current_player) if current_player.losses == 4
            next_player!
        end
    end
    
    def next_player!
        players.each_with_index do |player, idx|
            if player == current_player && (idx+1 == players.length)
                @current_player = players[0]
                break
            elsif player == current_player
                @current_player = players[idx+1]
                break
            end
        end
    end
    
    def record(player)
        player.losses += 1
    end
    
    def run
        get_players
        until players.length == 1
            @fragment = []
            @status = true
            @mod_dictionary = []
            dictionary.each { |word| @mod_dictionary << word }
            play_round
        end
        puts "#{players.first.name} wins!"
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
            record(player)
            @status = false
        end
        display_standings(player)
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
    my_dictionary = File.readlines("dictionary.txt").map(&:chomp)
    Game.new(dictionary: my_dictionary).run
end