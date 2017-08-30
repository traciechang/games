class HumanPlayer
  def initialize(name)
    @name = name
  end

  def get_play
    gets.chomp.split(",").map { |el| Integer(el) }
  end

  def prompt
    puts "Please enter a target square (i.e., '3,4')"
    print "> "
  end
end

class Ship
  attr_reader :size
  
  def initialize(size)
    @size = size
  end
end
