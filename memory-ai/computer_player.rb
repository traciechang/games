class ComputerPlayer
    attr_reader :name, :known_cards, :matched_cards, :all_spaces
    
    def initialize(name:)
        @name = name
        @known_cards = {}
        @matched_cards = []
        @all_spaces = []
    end
    
    def get_all_spaces
        (0..3).each do |row|
            (0..4).each do |col|
                all_spaces << [row, col]
            end
        end
    end
    
    def look_for_matches
        matching_spaces = []
        known_cards.each do |key, val|
            if val.length == 2
                matching_spaces = val.select do |space|
                    val.none? { |pos| matched_cards.include?(pos) }
                end
            end
        end
        matching_spaces
    end
    
    def get_guess
        if known_cards.empty? || look_for_matches == []
            random_guess
        else
            look_for_matches
        end
    end
    
    def random_guess
        random_space = all_spaces.sample
        until !matched_cards.include?(random_space)
            random_space = all_spaces.sample
        end
        random_space
    end
    
    def receive_revealed_card(guess:, val:)
        if known_cards.has_key?(val)
            @known_cards[val] << guess
        else
            @known_cards[val] = [guess]
        end
    end
    
    def receive_match(guess1, guess2)
        @matched_cards << guess1
        @matched_cards << guess2
    end
end