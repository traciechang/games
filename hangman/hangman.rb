require 'byebug'

class Hangman
  TOTAL_GUESSES = 8
  attr_reader :guesser, :referee, :board, :remaining_guesses

  def initialize(players = {})
    @guesser = players[:guesser]
    @referee = players[:referee]
    @board = board
    @remaining_guesses = TOTAL_GUESSES
  end

  def setup
    secret_word_length = referee.pick_secret_word
    guesser.register_secret_length(secret_word_length)
    @board = [nil] * secret_word_length
  end

  def take_turn
    guessed_letter = guesser.guess(board)
    correct_letters_indices = referee.check_guess(guessed_letter)
    update_board(guessed_letter, correct_letters_indices)
    guesser.handle_response(guessed_letter, correct_letters_indices)
    @remaining_guesses -= 1 if correct_letters_indices == []
  end

  def update_board(guessed_letter, correct_letters_indices)
    correct_letters_indices.each do |idx|
      board.each_with_index do |space, i|
        board[i] = guessed_letter if idx == i
      end
    end
  end

  def play
    setup
    until remaining_guesses == 0 || ((board.include? nil) == false)
      take_turn
    end

    if remaining_guesses != 0
      puts "You win!"
    else
      puts "Maybe next time!"
    end
  end
end

class HumanPlayer
  attr_reader :letters_guessed

  def initialize
    @letters_guessed = []
  end

  def pick_secret_word
    puts "Enter length of secret word:"
    secret_word_length = gets.chomp.strip.to_i
  end

  def register_secret_length(secret_word_length)
    puts "Length of secret word is #{secret_word_length}."
  end

  def guess(board)
    print board
    puts "Letters you've already guessed: #{letters_guessed}"
    puts "Enter your guess:"
    guessed_letter = gets.chomp.strip
    @letters_guessed << guessed_letter
    guessed_letter
  end

  def check_guess(guessed_letter)
    puts "Enter positions where letter \'#{guessed_letter}\' is correct. Example format is \'0, 1\'. Enter \'none\' if \'#{guessed_letter}\' does not appear in your word."
    answer = gets.chomp.strip
    if answer == "none"
      []
    else
      answer.split(", ").map { |el| el.to_i }
    end
  end

  def handle_response(guessed_letter, correct_letters_indices)
    puts "\'#{guessed_letter}\' appears in the following spaces: #{correct_letters_indices}"
  end
end

class ComputerPlayer

  attr_reader :dictionary, :secret_word, :secret_word_length, :filtered_dictionary

  def self.with_dict_file(filename)
    ComputerPlayer.new(File.readlines(filename).map(&:chomp))
  end

  def initialize(dictionary)
    @dictionary = dictionary
    @secret_word = secret_word
    @secret_word_length = secret_word_length
    @filtered_dictionary = dictionary
  end

  def pick_secret_word
    @secret_word = dictionary.sample
    @secret_word_length = secret_word.length
  end

  def check_guess(guessed_letter)
    correct_letters_indices = []
    secret_word.each_char.with_index { |letter, idx| correct_letters_indices << idx if guessed_letter == letter }
    correct_letters_indices
  end

  def register_secret_length(secret_word_length)
    @filtered_dictionary = dictionary.select { |word| word.length == secret_word_length }
  end

  def guess(board)
    alphabet_hash = ("a".."z").to_a.each_with_object({}) do |letter, obj|
      obj[letter] = 0
    end

    filtered_dictionary.each do |word|
      word.each_char do |letter|
        alphabet_hash[letter] += 1
      end
    end

    if board.all? { |space| space == nil }
      alphabet_hash.key(alphabet_hash.values.max)
    else
      alphabet_hash.values.sort.reverse.each do |val|
        if board.include?(alphabet_hash.key(val)) == false
          return alphabet_hash.key(val)
        end
      end
    end
  end

  def handle_response(guessed_letter, correct_letters_indices)
    filtered_words = []

    if correct_letters_indices == []
      filtered_dictionary.each do |word|
        filtered_words << word unless word.include? guessed_letter
      end
    else
      filtered_dictionary.each do |word|
        guessed_letters_in_word = 0

        word.each_char do |letter|
          guessed_letters_in_word += 1 if letter == guessed_letter
        end

        filtered_words << word if correct_letters_indices.all? { |idx| word[idx] == guessed_letter && guessed_letters_in_word == correct_letters_indices.length }
      end
    end
    @filtered_dictionary = filtered_words.sort
  end

  def candidate_words
    filtered_dictionary
  end
end

if __FILE__ == $PROGRAM_NAME
  print "Do you want to be the guesser? (yes/no)"
  answer = gets.chomp.strip
  if answer == "yes"
    guesser = HumanPlayer.new
    referee = ComputerPlayer.with_dict_file("dictionary.txt")
  else
    referee = HumanPlayer.new
    guesser = ComputerPlayer.with_dict_file("dictionary.txt")
  end
  Hangman.new({guesser: guesser, referee: referee}).play
end