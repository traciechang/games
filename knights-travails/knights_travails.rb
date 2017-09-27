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


class PolyTreeNode
    attr_reader :value, :parent, :children
    
    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end
    
    def parent
        @parent
    end
    
    def children
        @children
    end
    
    def value
        @value
    end
    
    def parent=(parent)
        @parent.children.delete(self) if @parent
        @parent = parent
        @parent.children << self if !parent.nil?
    end
    
    def add_child(child_node)
        child_node.parent = self
    end
    
    def remove_child(child_node)
        raise "Duplicate child" if child_node && !self.children.include?(child_node)
        child_node.parent = nil
    end
    
    def dfs(target_value)
        return self if self.value == target_value
        self.children.each do |child|
            search_result = child.dfs(target_value)
            return search_result unless search_result.nil?
        end
        nil
    end
    
    def bfs(target_value)
        nodes = [self]
        until nodes.empty?
            first = nodes.shift
            return first if first.value == target_value
            nodes = nodes + first.children
        end
        nil
    end
end

hi = KnightPathFinder.new([0,0])
hi.build_move_tree
end_node = hi.find_path([7,6])
p hi.trace_path_back(end_node)