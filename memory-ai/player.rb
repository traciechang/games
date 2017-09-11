class Player
    attr_reader :name
    
    def initialize(name:)
        @name = name
    end
    
    def get_guess
        puts "Which card to flip? (Enter card position as '00')"
        gets.chomp.split("").map(&:to_i)
    end
    
end