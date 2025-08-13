require 'rails_helper'

RSpec.describe FootballScoreboard, type: :model do
  let(:game) { create(:game) }
  let(:scoreboard) { create(:football_scoreboard, game: game) }

  describe 'timeout functionality' do
    it 'starts with 3 timeouts for each team' do
      expect(scoreboard.home_timeouts_remaining).to eq(3)
      expect(scoreboard.visitor_timeouts_remaining).to eq(3)
    end

    describe '#use_home_timeout!' do
      it 'decrements home timeouts when available' do
        expect { scoreboard.use_home_timeout! }.to change(scoreboard, :home_timeouts_remaining).from(3).to(2)
      end

      it 'returns false when no timeouts remaining' do
        scoreboard.update!(home_timeouts_remaining: 0)
        expect(scoreboard.use_home_timeout!).to be false
        expect(scoreboard.errors[:home_timeouts_remaining]).to include('No timeouts remaining')
      end
    end

    describe '#use_visitor_timeout!' do
      it 'decrements visitor timeouts when available' do
        expect { scoreboard.use_visitor_timeout! }.to change(scoreboard, :visitor_timeouts_remaining).from(3).to(2)
      end

      it 'returns false when no timeouts remaining' do
        scoreboard.update!(visitor_timeouts_remaining: 0)
        expect(scoreboard.use_visitor_timeout!).to be false
        expect(scoreboard.errors[:visitor_timeouts_remaining]).to include('No timeouts remaining')
      end
    end

    describe '#reset_timeouts_for_half!' do
      it 'resets both teams to 3 timeouts' do
        scoreboard.update!(home_timeouts_remaining: 1, visitor_timeouts_remaining: 0)
        scoreboard.reset_timeouts_for_half!
        
        expect(scoreboard.home_timeouts_remaining).to eq(3)
        expect(scoreboard.visitor_timeouts_remaining).to eq(3)
      end
    end
  end

  describe 'validations' do
    it 'validates timeout ranges' do
      scoreboard.home_timeouts_remaining = -1
      expect(scoreboard).to_not be_valid
      expect(scoreboard.errors[:home_timeouts_remaining]).to include('must be greater than or equal to 0')
      
      scoreboard.home_timeouts_remaining = 4
      expect(scoreboard).to_not be_valid
      expect(scoreboard.errors[:home_timeouts_remaining]).to include('must be less than or equal to 3')
    end
  end
end
