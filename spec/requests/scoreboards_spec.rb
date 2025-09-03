require 'rails_helper'

RSpec.describe "Scoreboards", type: :request do
  include Devise::Test::IntegrationHelpers
  
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }
  let(:game) { create(:game, :with_scoreboard, organization: organization) }
  let(:scoreboard) { game.scoreboard }

  before do
    sign_in user
  end

  describe "GET /games/:game_id/scoreboards/:id" do
    it "returns http success" do
      get game_scoreboard_path(game, scoreboard)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /games/:game_id/scoreboards/:id/edit" do
    it "returns http success" do
      get edit_game_scoreboard_path(game, scoreboard)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /games/:game_id/scoreboards/:id" do
    let(:update_params) do
      {
        football_scoreboard: {
          home_score: 14,
          visitor_score: 7,
          quarter: 'Q2',
          time_remaining: "08:45",
          home_timeouts_remaining: 2,
          visitor_timeouts_remaining: 1
        }
      }
    end

    it "successfully updates scoreboard with timeout values" do
      patch game_scoreboard_path(game, scoreboard), params: update_params
      
      expect(response).to redirect_to(game_scoreboard_path(game, scoreboard))
      
      scoreboard.reload
      expect(scoreboard.home_score).to eq(14)
      expect(scoreboard.visitor_score).to eq(7)
      expect(scoreboard.quarter).to eq('Q2')
      expect(scoreboard.home_timeouts_remaining).to eq(2)
      expect(scoreboard.visitor_timeouts_remaining).to eq(1)
    end
  end
end
