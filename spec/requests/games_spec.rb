require 'rails_helper'

RSpec.describe "Games", type: :request do
  include Devise::Test::IntegrationHelpers
  
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }
  let(:game) { create(:game, organization: organization) }

  before do
    sign_in user
  end

  describe "GET /games" do
    it "returns http success" do
      get games_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /games/:id" do
    it "returns http success" do
      get game_path(game)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /games/new" do
    it "returns http success" do
      get new_game_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /games/:id/edit" do
    it "returns http success" do
      get edit_game_path(game)
      expect(response).to have_http_status(:success)
    end
  end
end
