require_relative "board"

class HumanPlayer

    attr_accessor :name

    def initialize(name)
        @name = name
        #@board = board
    end

    def get_play
        puts "Enter your move. Example: if you want to place at [0, 0], enter 00."
        gets.chomp.strip.split("").map(&:to_i)
    end
end

class ComputerPlayer
    attr_accessor :board
    
    def initialize
        @board = Board.new
    end
    
    def get_play
        spaces_not_hit = []
        board.grid.each_with_index do |el, idx|
            el.each_with_index do |space, i|
                spaces_not_hit << [idx, i] if space == nil
            end
        end
        board[spaces_not_hit.sample]
    end
end
