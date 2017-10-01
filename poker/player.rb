class Player
    attr_reader :name, :hand
    attr_accessor :pot, :total_paid
    
    def initialize(name:, pot:)
        @name = name
        @hand = []
        @pot = pot
        @total_paid = 0
    end
    
    def get_discard_cards
        puts "Which cards to do you want to discard? Enter card position (0, 1, 2, etc.)"
        gets.chomp.split("").map(&:to_i)
    end
    
    def get_input
        puts "#{name}, do you want to fold, see, or raise? (f,s,r)"
        gets.chomp
    end
    
    def get_raise
        puts "Raise how much?"
        gets.chomp.to_i
    end
    
    def discard_card
        puts "#{name}, do you want to discard any cards? (y/n)"
        gets.chomp
    end
end