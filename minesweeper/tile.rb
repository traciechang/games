require_relative 'board'

class Tile
    attr_accessor :revealed, :value, :flagged
    attr_reader :board, :pos, :neighbors, :neighbor_bomb_count
    
    def initialize(board, pos)
        @revealed = false
        @value = nil
        @flagged = false
        @board = board
        @neighbors = []
        @neighbor_bomb_count = neighbors.count { |tile| tile.value == :b }
        @pos = pos
        
        neighbors << board[[pos[0], pos[1]-1]] if board[[pos[0], pos[1]-1]] != nil
        neighbors << board[[pos[0], pos[1]+1]] if board[[pos[0], pos[1]+1]] != nil
        neighbors << board[[pos[0]-1, pos[1]]] if board[[pos[0]-1, pos[1]]] != nil
        #neighbors << board[[pos[0]+1, pos[1]]] if board[[pos[0]+1, pos[1]]] != nil
        neighbors << board[[pos[0]-1, pos[1]-1]] if board[[pos[0]-1, pos[1]-1]] != nil
        neighbors << board[[pos[0]-1, pos[1]+1]] if board[[pos[0]-1, pos[1]+1]] != nil
        # neighbors << board[[pos[0]+1, pos[1]-1]] if board[[pos[0]+1, pos[1]-1]] != nil
        # neighbors << board[[pos[0]+1, pos[1]+1]] if board[[pos[0]+1, pos[1]+1]] != nil
    end
end