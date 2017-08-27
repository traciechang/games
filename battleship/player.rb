class HumanPlayer

    attr_accessor :name

    def initialize(name)
        @name = name
    end

    def get_play
        puts "Enter your move. Example: if you want to place at [0, 0], enter 00."
        gets.chomp.strip.split("")
    end
end
