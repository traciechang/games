class Player
    def initialize(name:)
        @name = name
    end
    
    def get_position
        puts "Enter board position. Format is '00'"
        gets.chomp.split("").map(&:to_i)
    end
    
    def get_move
        puts "Reveal or flag? (r/f)"
        gets.chomp.strip
    end
end