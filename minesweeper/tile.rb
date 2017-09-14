require_relative 'board'

class Tile
    NEIGHBORS_ARR = [
        [-1, -1],
        [-1,  0],
        [-1,  1],
        [ 0, -1],
        [ 0,  1],
        [ 1, -1],
        [ 1,  0],
        [ 1,  1]
      ]
    
    attr_accessor :revealed, :value, :flagged
    attr_reader :board, :pos, :neighbors, :neighbor_bomb_count
    
    def initialize(board, pos)
        @revealed = false
        @value = nil
        @flagged = false
        @board = board
        @pos = pos
    end
        
    def neighbor_bomb_count
        neighbors.count { |tile| tile.value == :b }
    end
    
    def neighbors
        neighbor_spaces = NEIGHBORS_ARR.map do |(x, y)|
            [pos[0] + x, pos[1] + y]
        end.select do |row, col|
            [row, col].all? do |coord|
                coord.between?(0, board.grid.length - 1)
            end
        end
        neighbor_spaces.map { |pos| board[pos] }
    end
end