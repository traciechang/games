require 'byebug'

class Board
  attr_accessor :cups, :name1, :name2

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14) { Array.new}
    
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    cups.each_with_index do |cup, idx|
      if ((idx != 6) && (idx != 13))
        4.times { cup << :stone }
      end
    end
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" if start_pos > 13 || start_pos < 1
  end

  def make_move(start_pos, current_player_name)
    cups[start_pos] = []
    current_pos = start_pos + 1
    stones = 4
    opp_side = current_player_name == @name1 ? 13 : 6
    
    until stones == 0
      unless current_pos == opp_side
        cups[current_pos] << :stone 
        stones -= 1
      end
      
      if current_pos == 13
        current_pos = 0
      else
        current_pos += 1
      end
    end
    
    render
    next_turn(current_pos)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
  end

  def winner
  end
end
