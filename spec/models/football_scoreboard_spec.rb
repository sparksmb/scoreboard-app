require 'rails_helper'

RSpec.describe FootballScoreboard, type: :model do
  let(:game) { create(:game) }
  let(:scoreboard) { create(:football_scoreboard, game: game) }

  describe 'quarter validations' do
    it 'accepts valid quarter string values' do
      valid_quarters = %w[PRE Q1 Q2 HALF Q3 Q4 OT FINAL]
      
      valid_quarters.each do |quarter|
        scoreboard = build(:football_scoreboard, quarter: quarter)
        expect(scoreboard).to be_valid, "Expected #{quarter} to be valid"
      end
    end
    
    it 'rejects invalid quarter values' do
      invalid_quarters = ['Q5', 'INVALID', 1, 2, 'PREGAME', 'HALFTIME']
      
      invalid_quarters.each do |quarter|
        scoreboard = build(:football_scoreboard, quarter: quarter)
        expect(scoreboard).not_to be_valid, "Expected #{quarter} to be invalid"
        expect(scoreboard.errors[:quarter]).to include('is not included in the list')
      end
    end
    
    it 'defaults to PRE when created through factory traits' do
      pre_game_scoreboard = create(:football_scoreboard, :pre_game)
      expect(pre_game_scoreboard.quarter).to eq('PRE')
    end
  end
  
  describe 'quarter-specific methods' do
    it '#overtime? returns true for OT quarter' do
      scoreboard = build(:football_scoreboard, quarter: 'OT')
      expect(scoreboard.overtime?).to be true
    end
    
    it '#overtime? returns false for regular quarters' do
      %w[PRE Q1 Q2 HALF Q3 Q4 FINAL].each do |quarter|
        scoreboard = build(:football_scoreboard, quarter: quarter)
        expect(scoreboard.overtime?).to be false
      end
    end
    
    it '#display_time shows quarter and time' do
      scoreboard = build(:football_scoreboard, quarter: 'Q2', time_remaining: '08:45')
      expect(scoreboard.display_time).to eq('Q2 08:45')
    end
    
    it '#display_time works with all quarter types' do
      quarters_and_expected = {
        'PRE' => 'PRE 12:00',
        'Q1' => 'Q1 12:00', 
        'HALF' => 'HALF 00:00',
        'OT' => 'OT 15:00',
        'FINAL' => 'FINAL 00:00'
      }
      
      quarters_and_expected.each do |quarter, expected|
        time = expected.split(' ')[1]
        scoreboard = build(:football_scoreboard, quarter: quarter, time_remaining: time)
        expect(scoreboard.display_time).to eq(expected)
      end
    end
  end
  
  describe 'factory traits' do
    it 'creates pre_game scoreboard correctly' do
      scoreboard = create(:football_scoreboard, :pre_game)
      expect(scoreboard.quarter).to eq('PRE')
      expect(scoreboard.time_remaining).to eq('12:00')
    end
    
    it 'creates halftime scoreboard correctly' do
      scoreboard = create(:football_scoreboard, :halftime)
      expect(scoreboard.quarter).to eq('HALF')
      expect(scoreboard.time_remaining).to eq('00:00')
    end
    
    it 'creates overtime scoreboard correctly' do
      scoreboard = create(:football_scoreboard, :overtime)
      expect(scoreboard.quarter).to eq('OT')
      expect(scoreboard.time_remaining).to eq('15:00')
    end
    
    it 'creates game_over scoreboard correctly' do
      scoreboard = create(:football_scoreboard, :game_over)
      expect(scoreboard.quarter).to eq('FINAL')
      expect(scoreboard.time_remaining).to eq('00:00')
    end
  end

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
