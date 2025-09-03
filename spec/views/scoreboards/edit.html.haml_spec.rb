require 'rails_helper'

RSpec.describe "scoreboards/edit.html.haml", type: :view do
  let(:organization) { create(:organization) }
  let(:home_team) { create(:team, organization: organization) }
  let(:visitor_team) { create(:team, organization: organization) }
  let(:game) { create(:game, home_team: home_team, visitor_team: visitor_team, organization: organization) }
  let(:football_scoreboard) { create(:football_scoreboard, game: game) }
  
  before do
    assign(:game, game)
    assign(:scoreboard, football_scoreboard)
  end
  
  context "for a football scoreboard" do
    it "renders the quick scoring buttons for home team" do
      render
      
      # Check that home team scoring buttons are present
      expect(rendered).to have_selector('button.scoring-btn[data-team="home"][data-points="6"]', text: 'TD (+6)')
      expect(rendered).to have_selector('button.scoring-btn[data-team="home"][data-points="1"]', text: 'PAT (+1)')
      expect(rendered).to have_selector('button.scoring-btn[data-team="home"][data-points="2"]', text: '2PT (+2)')
      expect(rendered).to have_selector('button.scoring-btn[data-team="home"][data-points="3"]', text: 'FG (+3)')
      expect(rendered).to have_selector('button.scoring-btn[data-team="home"][data-points="2"]', text: 'SAFETY (+2)')
    end
    
    it "renders the quick scoring buttons for visitor team" do
      render
      
      # Check that visitor team scoring buttons are present
      expect(rendered).to have_selector('button.scoring-btn[data-team="visitor"][data-points="6"]', text: 'TD (+6)')
      expect(rendered).to have_selector('button.scoring-btn[data-team="visitor"][data-points="1"]', text: 'PAT (+1)')
      expect(rendered).to have_selector('button.scoring-btn[data-team="visitor"][data-points="2"]', text: '2PT (+2)')
      expect(rendered).to have_selector('button.scoring-btn[data-team="visitor"][data-points="3"]', text: 'FG (+3)')
      expect(rendered).to have_selector('button.scoring-btn[data-team="visitor"][data-points="2"]', text: 'SAFETY (+2)')
    end
    
    it "renders the Quick Score headers" do
      render
      
      expect(rendered).to have_content('Quick Score')
    end
    
    it "includes JavaScript for handling scoring button clicks" do
      render
      
      expect(rendered).to include('document.addEventListener(\'DOMContentLoaded\'')
      expect(rendered).to include('document.querySelectorAll(\'.scoring-btn\')')
      expect(rendered).to include('football_scoreboard_home_score')
      expect(rendered).to include('football_scoreboard_visitor_score')
    end
  end
end
