require 'rspec'
require 'game'

describe Game do
    # let(:player1) {double("player1")}
    # let(:player2) {double("player2")}
    # let(:player3) {double("Player")}
    subject(:game) {Game.new}

    before :each do
        # game.players << player1
        # game.players << player2
        # game.players << player3
        game.distribute_cards
        game.init_hand
    end

    describe '#distribute_cards' do    
        it "distributes five cards to each player" do
            game.distribute_cards
            
            game.players.each do |player|
                expect(player.hand.hand.count).to eq(5)
            end
        end
    end

    describe "#play" do
        before :each do 
            game.place_initial_bet
            game.switch_player!
        end

        describe '#play_round' do
            it "places an initial bet" do
                game.play_round
                expect(game.pot).to_not eq(0)
            end
        end

        describe '#fold' do
            it 'eliminates the player from the rest of the game' do
                expect { game.fold }.to change {game.players.count}.by(-1)
            end
        end

        describe '#see' do
            it 'makes the current player\'s total paid match current high of pot' do
                game.see
                expect(game.current_player.total_paid).to eq(game.current_high)
            end
        end

        describe '#raise_bet' do
            it 'makes the current player pay current high plus amount raised' do
                game.raise_bet(5)
                expect(game.current_player.total_paid).to eq(game.current_high)
            end

            it 'goes thru all players for bets again until the person who raised' do
                game.raise_bet(5)
                expect(game.starting_player).to eq(game.current_player)
            end
        end

        describe '#discard' do
            before :each do
                game.delete_cards([0, 1])
            end

            describe '#delete_cards' do
                it 'discards specified cards' do
                    expect(game.current_player.hand.hand.count).to eq(3)
                end
            end

            describe '#add_new_cards' do
                it 'adds new cards to player\'s hand based on number of cards discarded' do
                    game.add_new_cards(2)
                    expect(game.current_player.hand.hand.count).to eq(5)
                end
            end
        end
    end
end