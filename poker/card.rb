require_relative 'player'

class Card
    attr_reader :value, :suit
    
    SUIT_STRINGS = {
        :clubs    => "♣",
        :diamonds => "♦",
        :hearts   => "♥",
        :spades   => "♠"
    }

    VALUE_STRINGS = {
        :two   => "2",
        :three => "3",
        :four  => "4",
        :five  => "5",
        :six   => "6",
        :seven => "7",
        :eight => "8",
        :nine  => "9",
        :ten   => "10",
        :jack  => "J",
        :queen => "Q",
        :king  => "K",
        :ace   => "A"
    }

    def display(card)
        puts "#{VALUE_STRINGS[card.value]} #{SUIT_STRINGS[card.suit]}"
    end
    
    def initialize(value:, suit:)
        @suit = suit
        @value = value
    end
    
    def self.suits
        SUIT_STRINGS.keys
    end
    
    def self.values
        VALUE_STRINGS.keys
    end
end