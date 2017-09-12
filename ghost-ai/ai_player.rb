class AiPlayer
    attr_accessor :name, :losses, :dictionary
    
    def initialize(name:, dictionary:)
        @name = name
        @losses = -1
        @dictionary = dictionary
    end
    
    def guess(fragment:, num_of_players:)
        guess_pool = ("a".."z").select do |letter|
            !dictionary.include?("#{fragment.join}#{letter}") && dictionary.any? { |word| word.start_with?("#{fragment.join}#{letter}") }
        end
        
        guess_pool = guess_pool.select do |letter|
            dictionary.each do |word|
                word.start_with?("#{fragment.join}#{letter}") && (word.length - (fragment.length + 1) <= num_of_players - 1)
            end
        end
        
        if guess_pool == []
            ("a".."z").sample
        else
            guess_pool.sample
        end
    end
    
    def alert_invalid_guess
        puts "Invalid guess"
    end
end