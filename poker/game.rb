require_relative 'player'
require_relative 'deck'
require_relative 'card'
require_relative 'hand'
# require 'byebug'

class Game
    attr_reader :current_player, :players, :deck, :pot, :current_high, :starting_player

    def add_new_cards(num_of_cards)
        num_of_cards.times { current_player.hand.hand << deck.pop}
    end
    
    def calculate_hand_results
        results_hash = {}
        players.each do |player|
            results_hash[player] = player.hand.hand_value
        end
        results_hash
    end
        
    def highest_score
        calculate_hand_results.values.max
    end
        
    def calculate_possible_winners    
        results_hash = calculate_hand_results
        results_hash.select do |player|
            results_hash[player] == highest_score
        end.keys
    end
    
    def delete_cards(card_positions)
        cards_to_delete = []
        card_positions.each do |pos|
            cards_to_delete << current_player.hand.hand[pos]
        end
        
        cards_to_delete.each do |card|
            current_player.hand.hand.delete(card)
        end
    end
    
    def discard
        display_cards
        answer = current_player.discard_card
        if answer == 'y'
            cards_to_discard = current_player.get_discard_cards
            num_cards_to_discard = cards_to_discard.length
            
            delete_cards(cards_to_discard)
            add_new_cards(num_cards_to_discard)
        end
        switch_player!
    end
    
    def display_cards
        puts "#{current_player.name}\'s hand:"
        current_player.hand.hand.each do |card|
            card.display(card)
        end
    end
    
    def display_winner
        possible_winners = calculate_possible_winners
        players_best_cards = {}
        winner = nil
        current_greatest = 0
        if possible_winners.count == 1
            puts "#{possible_winners.first.name} wins!"
        else
            possible_winners.each do |player|
                players_best_cards[player] = player.hand.handle_multiple_winners(highest_score)
            end
            
            players_best_cards.each do |key, val|
                if key.hand.get_value(val) > current_greatest
                    current_greatest = key.hand.get_value(val)
                    winner = key
                end
            end
            puts "#{winner.name} wins!"
        end
    end
    
    def distribute_cards
        5.times do
            players.each do |player|
                new_card = deck.pop
                player.hand << new_card
            end
        end
    end
    
    def fold
        current_player_idx = players.index(current_player)
        @current_player = players[current_player_idx - 1]
        players.delete(players[current_player_idx])
    end
    
    def get_players
        answer = "y"
        while answer == "y"
            puts "Do you want to add a player? (y/n)"
            answer = gets.chomp
            if answer == "y"
                puts "Enter player name:"
                name = gets.chomp
                players << Player.new(name: name, pot: 100)
            end
        end
    end
    
    def handle_high_card(hand)
        hand.high_card
    end
    
    def init_hand
        players.each do |player|
            player.hand = Hand.new(player.hand)
        end
    end
    
    def initialize
        @deck = Deck.new.shuffle_deck
        # for ease of testing
        @players = [Player.new(name: "Dany", pot: 20), Player.new(name: "Jon", pot: 15), Player.new(name: "Tyrion", pot: 30)]
        # @players = []
        # get_players
        @current_player = @players[1]
        @current_high = 0
        @pot = 0
        @starting_player = @players.first
    end
    
    
    def place_bet(player, amount)
        player.pot -= amount
        player.total_paid += amount
        @pot += amount
    end
    
    def place_initial_bet
        place_bet(players.first, 2)
        @current_high = 2
    end
    
    def play
        # get_players
        distribute_cards
        init_hand
        play_round

        @current_player = players.first
        discard
        until current_player == players.first
            discard
        end

        @current_player = players[1]
        play_round

        display_winner
    end
    
    def play_round
        place_initial_bet
        until current_player == starting_player
            display_cards
            take_turn
            switch_player!
        end
    end
    
    def see
        place_bet(current_player, current_high - current_player.total_paid)
    end
    
    def raise_bet(amount)
        @starting_player = current_player
        place_bet(current_player, (current_high - current_player.total_paid) + amount)
        @current_high += amount
    end
    
    def switch_player!
        if current_player == players.last
            @current_player = players.first
        else
            current_player_idx = players.index(current_player)
            @current_player = players[current_player_idx + 1]
        end
    end
    
    def take_turn
        puts "#{current_player.name}\'s turn. You have $#{current_player.pot} to bet. Current bet is #{current_high}."
        player_input = current_player.get_input
        case player_input
        when "f"
            fold
        when "s"
            see
        when "r"
            raise_bet(current_player.get_raise)
        end
    end
end

# new = Game.new
# new.play

