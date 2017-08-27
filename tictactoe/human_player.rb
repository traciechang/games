require "byebug"

class HumanPlayer
  attr_accessor :name, :mark

  def initialize(name)
    @name = name
    @mark = :X
  end

  def display(board)
    print "
      #{board.grid[0]}
      #{board.grid[1]}
      #{board.grid[2]}
    "
  end

  def get_move
    puts "where do you want to place your mark?"
    human_input = gets.chomp
    human_input_arr = human_input.split(", ").map { |num| num.to_i}
  end
end
