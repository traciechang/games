require 'byebug'

class Code
  attr_reader :pegs

  PEGS = Hash.new(Array.new(4))
  VALID_PEG_COLORS = ["R", "G", "B", "Y", "O", "P"]

  def initialize(pegs)
    @pegs = pegs
  end

  def self.parse(pegs)
    if pegs.upcase.split("").all? { |peg| VALID_PEG_COLORS.include? peg }
      Code.new(pegs.upcase.split(""))
    else
      raise "Invalid colors"
    end
  end

  def self.random
    Code.new(VALID_PEG_COLORS.combination(4).to_a.sample)
  end
#ian explain - don't know what they are askin for & what it means
#and why do i have to define this
#i think this is what is messing up my random method
  def [](idx)
    pegs[idx]
  end

  def exact_matches(secret_code)
    corr_col_corr_pos = 0
    (0..3).each { |idx| corr_col_corr_pos += 1 if self[idx] == secret_code[idx] }
    corr_col_corr_pos
  end

  def near_matches(secret_code)
    corr_col = 0
    guess_hash = {}
    secret_hash = {}

    (0..3).each do |idx|
      if self[idx] != secret_code[idx]
        if guess_hash.include? [self[idx]]
          guess_hash[self[idx]] += 1
        else
          guess_hash[self[idx]] = 1
        end

        if secret_hash.include? [secret_code[idx]]
          secret_hash[secret_code[idx]] += 1
        else
          secret_hash[secret_code[idx]] = 1
        end
      end
    end

    guess_hash.each do |key, val|
      if secret_hash.keys.include? key
        corr_col += (secret_hash[key] < guess_hash[key] ? secret_hash[key] : guess_hash[key])
      end
    end
    corr_col
  end

  def ==(obj)
    if obj.class != Code
      false
    else
      return true if self.pegs == obj.pegs
    end
  end
end

class Game
  attr_reader :secret_code, :guessed_code

  def initialize(secret_code = Code.random)
    @secret_code = secret_code
    @guessed_code = guessed_code
  end

  def get_guess
    puts "Enter your guess:"
    begin
      @guessed_code = Code.parse(gets.chomp)
    rescue
      puts "Error parsing code"
      retry
    end
  end

  def display_matches(guessed_code)
    print "exact matches: #{guessed_code.exact_matches(secret_code)}"
    print "near matches: #{guessed_code.near_matches(secret_code)}"
  end
end