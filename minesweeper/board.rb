require 'byebug'
require_relative 'tile'

class Board
    DISPLAY = {
        :b => ["b", "r", "f"],
        nil => ["*", "_", "f"]
    }
    
    attr_reader :grid
    
    def initialize
        @grid = Array.new(9) { Array.new(9) }
        grid.each_with_index do |row, idx|
            row.each_with_index do |col, i|
                self[[idx, i]] = Tile.new(self, [idx, i])
            end
        end
    end
    
    def [](pos)
        row, col = pos
        @grid[row][col]
    end

    def []=(pos, mark)
        row, col = pos
        @grid[row][col] = mark
    end
    
    def display
        p "   0  1  2  3  4  5  6  7  8"
        grid.each_with_index do |row, idx|
            p "#{idx.to_s}  #{display_row(row, idx)}"
        end
    end
    
    def display_row(row, idx)
        row.map.with_index do |el, i|
            if self[[idx, i]].revealed == true
                DISPLAY[el.value][1]
            elsif self[[idx, i]].flagged == true
                 DISPLAY[el.value][2]
            else
                DISPLAY[el.value][0]
            end     
        end.join("  ")
    end
    
    def seed
        5. times { self[[rand(0..8), rand(0..8)]].value = :b }
    end
end
