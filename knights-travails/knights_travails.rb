require 'byebug'

class KnightPathFinder
    MOVES = [
        [2, 1],
        [2, -1],
        [1, 2],
        [1, -2],
        [-1, 2],
        [-1, -2],
        [-2, 1],
        [-2, -1]
        ]
    
    attr_reader :start_pos, :move_tree, :visited_positions
    
    def initialize(start_pos)
        @start_pos = start_pos
        @move_tree = []
        @visited_positions = [start_pos]
    end
    
    def build_move_tree
        nodes = [PolyTreeNode.new(start_pos)]
        until nodes.empty?
            first = nodes.shift
            @move_tree << first
            new_move_positions(first.value).each do |child|
                new_node = PolyTreeNode.new(child)
                first.add_child(new_node)
            end
            nodes = nodes + first.children
        end
    end
    
    def find_path(end_pos)
        nodes = [move_tree.first]
        until nodes.empty?
            first = nodes.shift
            return first if first.value == end_pos
            nodes = nodes + first.children
        end
        nil
    end
    
    def new_move_positions(pos)
        all_possible_moves = valid_moves(pos)
        new_moves = all_possible_moves.select { |move| !visited_positions.include?(move) }
        @visited_positions += new_moves
        new_moves
    end
    
    def trace_path_back(end_node)
        return [end_node.value] if end_node.parent.nil?
        trace_path_back(end_node.parent) + [end_node.value]
    end
    
    def valid_moves(pos)
        MOVES.map do |move|
            x = pos[0] + move[0]
            y = pos[1] + move[1]
            [x, y] if ((x > -1 && x < 9) && (y > -1 && y < 9))
        end.select { |move| !move.nil?}.sort
    end
end


