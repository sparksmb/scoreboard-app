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
end
