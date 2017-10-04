require_relative 'card'

class Deck
    attr_reader :deck
    
    def self.generate_cards
        Card.suits.product(Card.values).map do |suit, val|
            Card.new(suit: suit, value: val)
        end
    end
    
    def initialize(deck = Deck.generate_cards)
        @deck = deck
    end
    
    def shuffle_deck
        deck.shuffle
    end
end

# p Deck.new