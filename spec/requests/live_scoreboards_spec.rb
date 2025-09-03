require 'rails_helper'

RSpec.describe "LiveScoreboards", type: :request do
  include Devise::Test::IntegrationHelpers
  
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }

  before do
    sign_in user
  end

  describe "GET /organizations/:organization_id/scoreboard" do
    
    context "when there are no games" do
      it "shows 'No upcoming games scheduled'" do
        get organization_scoreboard_path(organization)
        
        expect(response).to have_http_status(:success)
        expect(response.body).to include('No upcoming games scheduled')
      end
    end
    
    context "when there are games with scoreboards" do
      let!(:upcoming_game) { create(:game, :with_scoreboard, organization: organization, game_date: 2.hours.from_now) }
      
      it "shows the live scoreboard" do
        get organization_scoreboard_path(organization)
        
        expect(response).to have_http_status(:success)
        expect(response.body).to include('live-scoreboard')
        expect(response.body).not_to include('No upcoming games scheduled')
      end
      
      it "displays the quarter value directly" do
        upcoming_game.scoreboard.update!(quarter: 'Q2')
        
        get organization_scoreboard_path(organization)
        
        expect(response.body).to include('Q2')
      end
      
      it "displays PRE quarter for pre-game scoreboards" do  
        upcoming_game.scoreboard.update!(quarter: 'PRE')
        
        get organization_scoreboard_path(organization)
        
        expect(response.body).to include('PRE')
      end
      
      it "displays HALF quarter for halftime scoreboards" do
        upcoming_game.scoreboard.update!(quarter: 'HALF')
        
        get organization_scoreboard_path(organization)
        
        expect(response.body).to include('HALF')
      end
    end
    
    context "game cutoff logic" do
      it "shows games that started within the last 4 hours" do
        # Game that started 3 hours ago (should show)
        recent_game = create(:game, :with_scoreboard, organization: organization, game_date: 3.hours.ago)
        
        get organization_scoreboard_path(organization)
        
        expect(response).to have_http_status(:success)
        expect(response.body).to include('live-scoreboard')
        expect(response.body).not_to include('No upcoming games scheduled')
      end
      
      it "shows the earliest game when multiple games are available" do
        # Create games in different time ranges
        later_game = create(:game, :with_scoreboard, organization: organization, game_date: 2.hours.from_now)
        earlier_game = create(:game, :with_scoreboard, organization: organization, game_date: 1.hour.from_now)
        
        get organization_scoreboard_path(organization)
        
        expect(response).to have_http_status(:success)
        expect(response.body).to include('live-scoreboard')
        expect(response.body).not_to include('No upcoming games scheduled')
      end
    end
  end
end
