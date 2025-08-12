require 'rails_helper'

RSpec.feature "Screenshot Methods Demo", type: :feature do
  let(:admin_user) { create(:user, :admin, first_name: "Screenshot", last_name: "Demo") }
  
  scenario "demonstrating all screenshot methods" do
    login_as(admin_user, scope: :user)
    visit admin_organizations_path
    
    # Basic screenshot - saves and opens automatically
    # ss
    
    # Named screenshot - saves with custom name and opens
    # ss(name: "organizations_index")
    
    # Full page screenshot - captures entire page
    # ss_full(name: "full_page_organizations")
    
    # Quiet screenshot - saves but doesn't open
    # ss_quiet(name: "quiet_screenshot")
    
    # Debug screenshot - uses the debug helper method  
    # debug_screenshot("debug_organizations")
    
    # Combined with Pry debugging
    if ENV['DEBUG']
      puts "\n🐛 About to take screenshots for debugging..."
      
      # Take a named screenshot
      ss(name: "before_form_interaction", open: false)
      
      # Show debug info and break
      debug_everything("At organizations page with screenshot")
    end
    
    # Continue with test
    expect(page).to have_content("Organizations")
    
    # Take screenshot before form interaction
    # ss(name: "before_clicking_new")
    
    click_link "New Organization"
    
    # Take screenshot of the form
    # ss(name: "new_organization_form")
    
    expect(page).to have_content("New Organization")
  end
  
  # This test shows how to use screenshots in failing scenarios
  scenario "screenshot on failure example" do
    login_as(admin_user, scope: :user)
    visit admin_organizations_path
    
    begin
      # This might fail
      expect(page).to have_content("Non-existent content")
    rescue RSpec::Expectations::ExpectationNotMetError => e
      # Take a screenshot when test fails for debugging
      ss(name: "test_failure_debug", open: true)
      raise e  # Re-raise the error
    end
  end
end
