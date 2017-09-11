require_relative 'card'

class Board
    attr_reader :cards, :grid
    
    def initialize
        @cards = []
        @grid = Array.new(4) { Array.new(5) }
        
    end
    
    def [](pos)
        row, col = pos
        @grid[row][col]
    end
    
    def []=(pos, value)
        row, col = pos
        @grid[row][col] = value
    end
    
    def create_cards
        (0..9).each do |num|
            2.times { cards << Card.new(face_value: num) }
        end
    end
    
    def display
        grid.each_with_index do |row, i|
            display_row(row, i)
        end
    end
    
    def display_row(row, i)
        chars = []
        row.map.with_index do |el, idx|
            if el.face_up
                chars << el.face_value
            else
                chars << el.back
            end
        end
        chars = chars.join(" ")
        p chars
    end
    
    def get_avail_spaces
        avail_spaces = []
        grid.each_with_index do |row, idx|
            row.each_with_index do |col, i|
                avail_spaces << [idx, i]
            end
        end
        avail_spaces
    end
    
    def populate
        avail_spaces = get_avail_spaces
        cards.each do |card|
            random_space = avail_spaces.sample
            self[random_space] = card
            avail_spaces.delete(random_space)
        end
    end
    
    def reveal
    end
    
    def won?
        grid.flatten.all? { |el| el.face_up == true }
    end
    
    
end
