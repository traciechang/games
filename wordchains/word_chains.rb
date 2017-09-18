require 'byebug'
require 'set'

class WordChainer
    attr_reader :dictionary, :current_word, :current_words, :all_seen_words
    
    def initialize(dictionary_file_name)
        @dictionary = dictionary_file_name
        @current_word = ""
        @current_words = []
        @all_seen_words = {}
    end
    
    def adjacent_words(word)
        adjacent_words_arr = []
        word.each_char.with_index do |letter, idx|
            ("a".."z").each do |alpha_letter|
                if letter != alpha_letter
                    temp_word = word.dup
                    temp_word[idx] = alpha_letter
                    adjacent_words_arr << temp_word if valid_word?(temp_word)
                end
            end
        end
        adjacent_words_arr
    end
    
    def build_path(target)
        return [target] if all_seen_words[target] == nil
        build_path(all_seen_words[target]) + [target]
    end
    
    def explore_current_words
        new_current_words = []
        # display = {}
        current_words.each do |word|
            adjacent_words(word).each do |adj_word|
                if !all_seen_words.include?(adj_word)
                    @all_seen_words[adj_word] = word
                    new_current_words << adj_word
                end
            end
        end
        # new_current_words.each do |curr_word|
        #     display[curr_word] = all_seen_words[curr_word]
        # end
        new_current_words
    end
    
    def run(source, target)
        @current_word  = source
        @current_words << source
        @all_seen_words[source] = nil
        
        until all_seen_words.include?(target) || current_words.empty?
            @current_words = explore_current_words
            current_words
        end
        
        p build_path(target)
    end
    
    def valid_word?(word)
        dictionary.include?(word)
    end
end

if __FILE__ == $PROGRAM_NAME
    dict_file = File.readlines("dictionary.txt").map(&:chomp).to_set
    WordChainer.new(dict_file).run("market", "ticker")
end