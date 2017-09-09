class Player
    attr_accessor :name, :losses
    
    def initialize(name:)
        @name = name
        @losses = -1
    end
    
    def guess
        puts "#{name}, enter your guess:"
        gets.chomp.strip.downcase
    end
    
    def alert_invalid_guess
        puts "Invalid guess"
    end
end