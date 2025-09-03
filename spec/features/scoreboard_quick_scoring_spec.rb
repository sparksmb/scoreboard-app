require 'rails_helper'

RSpec.feature "Scoreboard Quick Scoring UI", type: :feature do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }
  let(:home_team) { create(:team, organization: organization, name: "Home Team") }
  let(:visitor_team) { create(:team, organization: organization, name: "Visitor Team") }
  let(:game) { create(:game, home_team: home_team, visitor_team: visitor_team, organization: organization) }
  let(:football_scoreboard) do
    create(:football_scoreboard, 
           game: game, 
           home_score: 0, 
           visitor_score: 0)
  end

  before do
    login_as(user, scope: :user)
  end

  scenario "displays visitor team on the left with quick scoring buttons" do
    visit edit_game_scoreboard_path(game, football_scoreboard)

    within('.visitor-team') do
      # Verify all scoring buttons are present with correct attributes
      expect(page).to have_button('TD (+6)')
      expect(page).to have_button('PAT (+1)')
      expect(page).to have_button('2PT (+2)')
      expect(page).to have_button('FG (+3)')
      expect(page).to have_button('SAFETY (+2)')
      
      # Check data attributes
      fg_button = find('button', text: 'FG (+3)')
      expect(fg_button['data-team']).to eq('visitor')
      expect(fg_button['data-points']).to eq('3')
      expect(fg_button[:type]).to eq('button')
      
      # Check Quick Score header
      expect(page).to have_content('Quick Score')
    end
  end

  scenario "displays home team on the right with quick scoring buttons" do
    visit edit_game_scoreboard_path(game, football_scoreboard)

    within('.home-team') do
      # Verify all scoring buttons are present with correct attributes
      expect(page).to have_button('TD (+6)')
      expect(page).to have_button('PAT (+1)')
      expect(page).to have_button('2PT (+2)')
      expect(page).to have_button('FG (+3)')
      expect(page).to have_button('SAFETY (+2)')
      
      # Check data attributes
      td_button = find('button', text: 'TD (+6)')
      expect(td_button['data-team']).to eq('home')
      expect(td_button['data-points']).to eq('6')
      expect(td_button[:type]).to eq('button')
    end
  end

  scenario "buttons have proper styling and colors" do
    visit edit_game_scoreboard_path(game, football_scoreboard)

    # Check that buttons have different background colors as specified
    td_button = find('.home-team button[data-points="6"]')
    pat_button = find('.home-team button[data-points="1"]')
    fg_button = find('.home-team button[data-points="3"]')
    
    # Verify buttons have the cursor pointer style (indicates they're clickable)
    expect(td_button[:style]).to include('cursor: pointer')
    expect(pat_button[:style]).to include('cursor: pointer')
    expect(fg_button[:style]).to include('cursor: pointer')
    
    # Verify different background colors
    expect(td_button[:style]).to include('#28a745') # Green for TD
    expect(pat_button[:style]).to include('#17a2b8') # Teal for PAT
    expect(fg_button[:style]).to include('#007bff')  # Blue for FG
  end

  scenario "page includes JavaScript for handling button clicks" do
    visit edit_game_scoreboard_path(game, football_scoreboard)
    
    # Check that the JavaScript is included in the page source
    expect(page.html).to include('DOMContentLoaded')
    expect(page.html).to include('scoring-btn')
    expect(page.html).to include('football_scoreboard_home_score')
    expect(page.html).to include('football_scoreboard_visitor_score')
  end

  scenario "form maintains functionality with regular score inputs" do
    visit edit_game_scoreboard_path(game, football_scoreboard)

    # Manually enter scores in the input fields
    fill_in 'football_scoreboard_home_score', with: '21'
    fill_in 'football_scoreboard_visitor_score', with: '14'
    
    # Submit the form
    click_button 'Update Scoreboard'

    # Should redirect to the scoreboard show page
    expect(current_path).to eq(game_scoreboard_path(game, football_scoreboard))

    # Verify the scores were saved
    football_scoreboard.reload
    expect(football_scoreboard.home_score).to eq(21)
    expect(football_scoreboard.visitor_score).to eq(14)
  end
  
  scenario "quick scoring section only appears for football scoreboards" do
    visit edit_game_scoreboard_path(game, football_scoreboard)
    
    # Should have scoring buttons for football
    expect(page).to have_content('Quick Score')
    expect(page).to have_button('TD (+6)')
  end
  
  scenario "visitor team appears on the left, home team on the right" do
    visit edit_game_scoreboard_path(game, football_scoreboard)
    
    # Find both team sections
    visitor_section = find('.visitor-team')
    home_section = find('.home-team')
    
    # Verify visitor team name appears in visitor section
    within(visitor_section) do
      expect(page).to have_content(visitor_team.name)
    end
    
    # Verify home team name appears in home section
    within(home_section) do
      expect(page).to have_content(home_team.name)
    end
    
    # Verify the DOM order - visitor should come before home in the HTML
    score_section = find('.score-section')
    expect(score_section.text).to match(/#{visitor_team.name}.*#{home_team.name}/m)
  end
end
