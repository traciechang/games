require_relative 'card'
# require 'byebug'
class Hand
    attr_reader :hand, :suit_hash, :values_hash
    
    VALUES = {
        :two   => 2,
        :three => 3,
        :four  => 4,
        :five  => 5,
        :six   => 6,
        :seven => 7,
        :eight => 8,
        :nine  => 9,
        :ten   => 10,
        :jack  => 11,
        :queen => 12,
        :king  => 13,
        :ace   => 14
    }
    
    def all_values_unique?
        values_hash.count == 5
    end
    
    def all_same_suit?
        suit_hash.count == 1
    end

    def consecutive?
        arr = sorted_values
        arr == (arr.min..arr.max).to_a
    end
    
    def flush?
        all_same_suit?
    end
    
    def four_of_a_kind?
        values_hash.values.include?(4)
    end
    
    def full_house?
        values_hash.values.include?(3) && values_hash.values.include?(2)
    end
    
    def get_value(card)
        VALUES[card]
    end
    
    def handle_multiple_winners(max_val)
        case max_val
        when 1
            high_card
        when 2
            self.values_hash.key(2)
        when 3
            #
        when 4
            self.values_hash.key(3)
        when 5 
        when 6
        when 7
        when 8
        when 9
        end
    end
    
    def hand_value
        if royal_flush?
            return 10
        elsif straight_flush?
            return 9 
        elsif four_of_a_kind?
            return 8
        elsif full_house?
            return 7
        elsif flush?
            return 6
        elsif straight?
            return 5
        elsif three_of_a_kind?
            return 4
        elsif two_pair?
            return 3
        elsif pair?
            return 2
        end
        1
    end
    
    def initialize(hand)
        @hand = hand
        @suit_hash = {}
        @values_hash = {}
        
        @hand.each do |card|
            if @suit_hash.include?(card.suit)
                @suit_hash[card.suit] += 1
            else
                @suit_hash[card.suit] = 1
            end
            
            if @values_hash.include?(card.value)
                @values_hash[card.value] += 1
            else
                @values_hash[card.value] = 1
            end
        end
    end
    
    def high_card
        max_val = values_hash.map do |key, val|
            VALUES[key]
        end.max
        VALUES.key(max_val)
    end
    
    def pair?
        values_hash.values.include?(2)
    end
    
    def royal_flush?
        consecutive? && sorted_values.min == 10 && all_same_suit?
    end
    
    def sorted_values
        values_hash.map do |key, val|
            VALUES[key]
        end.sort
    end
    
    def straight?
        consecutive?
    end
    
    def straight_flush?
        consecutive? && all_same_suit?
    end
    
    def three_of_a_kind?
        values_hash.values.include?(3)
    end
    
    def two_pair?
        values_hash.select do |key, val|
            val == 2
        end.count == 2
    end
end

# handoftheking = Hand.new
# p handoftheking.high_card