require 'rails_helper'

RSpec.describe "Teams", type: :request do
  include Devise::Test::IntegrationHelpers
  
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }
  let(:team) { create(:team, organization: organization) }

  before do
    sign_in user
  end

  describe "GET /teams" do
    it "returns http success" do
      get teams_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /teams/:id" do
    it "returns http success" do
      get team_path(team)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /teams/new" do
    it "returns http success" do
      get new_team_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /teams/:id/edit" do
    it "returns http success" do
      get edit_team_path(team)
      expect(response).to have_http_status(:success)
    end
  end
end
