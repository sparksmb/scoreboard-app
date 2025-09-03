require 'rails_helper'

RSpec.describe "Games#new_scoreboard", type: :request do
  include Devise::Test::IntegrationHelpers
  
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }
  let(:game) { create(:game, organization: organization) }

  before do
    sign_in user
  end

  describe "POST /games/:id/new_scoreboard" do
    context "when game has no scoreboard" do
      it "creates a new scoreboard with PRE default quarter" do
        expect {
          post new_scoreboard_game_path(game)
        }.to change(Scoreboard, :count).by(1)
        
        expect(response).to redirect_to(game_path(game))
        expect(flash[:notice]).to eq('Scoreboard was successfully created.')
        
        scoreboard = game.reload.scoreboard
        expect(scoreboard).to be_present
        expect(scoreboard.type).to eq('FootballScoreboard')
        expect(scoreboard.quarter).to eq('PRE')
        expect(scoreboard.time_remaining).to eq('12:00')
        expect(scoreboard.home_score).to eq(0)
        expect(scoreboard.visitor_score).to eq(0)
        expect(scoreboard.home_timeouts_remaining).to eq(3)
        expect(scoreboard.visitor_timeouts_remaining).to eq(3)
        expect(scoreboard.time_remaining_visible).to be false
        expect(scoreboard.name_visible).to be false
      end
    end
    
    context "when game already has a scoreboard" do
      let!(:game_with_scoreboard) { create(:game, :with_scoreboard, organization: organization) }
      
      it "does not create a new scoreboard and shows error" do
        initial_count = Scoreboard.count
        
        post new_scoreboard_game_path(game_with_scoreboard)
        
        expect(Scoreboard.count).to eq(initial_count)
        expect(response).to redirect_to(game_path(game_with_scoreboard))
        expect(flash[:alert]).to eq('Game already has a scoreboard.')
      end
    end
    
    context "when user doesn't have access to organization" do
      let(:other_organization) { create(:organization) }
      let(:other_game) { create(:game, organization: other_organization) }
      
      it "denies access with 404" do
        expect {
          post new_scoreboard_game_path(other_game)
        }.not_to change(Scoreboard, :count)
        
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
