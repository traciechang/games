class Player
    attr_reader :name
    
    def initialize(name:)
        @name = name
    end
    
    def guess
        puts "#{name}, enter your guess:"
        gets.chomp.strip.downcase
    end
    
    def alert_invalid_guess
        puts "Invalid guess"
    end
end