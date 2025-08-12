require 'rails_helper'

RSpec.feature "Admin Organizations Management - Debug Example", type: :feature do
  let(:admin_user) { create(:user, :admin, first_name: "Debug", last_name: "Admin") }
  
  scenario "debugging organization creation with Pry" do
    login_as(admin_user, scope: :user)
    
    # Navigate to organizations page
    visit admin_organizations_path
    
    # Add a breakpoint here to inspect the page state
    binding.pry if ENV['DEBUG']
    
    expect(page).to have_content("Organizations")
    
    # Go to new organization form
    click_link "New Organization"
    
    # Another breakpoint to inspect the form
    binding.pry if ENV['DEBUG']
    
    expect(page).to have_content("New Organization")
    
    # Fill out the form
    fill_in "Name", with: "Debug Test District"
    select "Active", from: "Status"
    
    # Breakpoint before submitting
    binding.pry if ENV['DEBUG']
    
    click_button "Create Organization"
    
    # Final breakpoint to check the result
    binding.pry if ENV['DEBUG']
    
    expect(page).to have_content("Debug Test District")
    expect(page).to have_content("Active")
  end
end
