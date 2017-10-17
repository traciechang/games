require 'rspec'
require 'hand'

describe Hand do
    let(:card_AH) {double("Card", :suit => :hearts, :value => :ace)}
    let(:card_KH) {double("Card", :suit => :hearts, :value => :king)}
    let(:card_QH) {double("Card", :suit => :hearts, :value => :queen)}
    let(:card_JH) {double("Card", :suit => :hearts, :value => :jack)}
    let(:card_JS) {double("Card", :suit => :spades, :value => :jack)}
    let(:card_TH) {double("Card", :suit => :hearts, :value => :ten)}
    let(:card_TD) {double("Card", :suit => :diamonds, :value => :ten)}
    subject(:hand) { Hand.new([card_AH, card_KH, card_QH, card_JH, card_TH]) }
    # let(:hand1) {double("Hand", :hand => [card_AH, card_KH, card_QH, card_TD, card_TH])}
    let(:hand1) {double("Hand", :hand => [card_AH, card_KH, card_QH, card_TD, card_TH], :values_hash => {:ten => 2, :one => 1, :three => 1, :four => 1})}
    # let(:hand2) {double("Hand", :hand => [card_AH, card_JH, card_JS, card_TD, card_TH])}
    
    describe '#hand_value' do
        it 'returns the value correctly in the hierarchy' do
            expect(hand.hand_value).to be(10)
        end

        it 'will not return a lower match in the hierarchy when there is a higher one' do
            expect(hand.hand_value).to_not be(9)
        end
    end

    describe '#high_card' do
        it 'returns the highest card in the hand' do
            expect(hand.high_card).to eq (:ace)
        end
    end

    describe '#pair?' do
        it 'returns true only when there is one pair in the hand' do
            expect(hand1.pair?).to be true
        end
    end
    
    describe '#royal_flush?' do
        it 'contains only one suit for all five cards' do
            only_suit = hand.hand.first.suit
            expect(hand.hand.all? { |card| card.suit == only_suit }).to be true
        end
    end
  
    describe '#straight?' do
        it 'can be any five consecutive cards' do
            expect(hand.straight?).to be true
        end
    end

    describe '#straight_flush?' do
        it 'can be any five consecutive cards' do
            expect(hand.consecutive?).to be true
        end

        it 'contains only one suit for all five cards' do
            only_suit = hand.hand.first.suit
            expect(hand.hand.all? { |card| card.suit == only_suit }).to be true
        end
    end

    describe '#two_pair?' do
        it 'return true when there are two pairs in the hand' do
            expect(hand.two_pair?).to be false
        end
    end

    describe '#three_of_a_kind?' do
        it 'returns true when there are three of the same values' do
            expect(hand.three_of_a_kind?).to be false
        end
    end

    describe '#flush?' do
        it 'contains the same suit for all cards' do
            expect(hand.flush?).to be true
        end
    end
    
    describe '#four_of_a_kind?' do
        it 'contains four cards with the same value' do
            expect(hand.four_of_a_kind?).to be false
        end
    end

    describe '#full_house?' do
        it 'contains three cards of the same value and two cards of another value' do
            expect(hand.full_house?).to be false
        end
    end
    
end