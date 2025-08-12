require 'rails_helper'

RSpec.feature "Admin Sign In", type: :feature do
  let!(:admin_user) { create(:user, :admin, email: 'admin@test.com', password: 'admin123', password_confirmation: 'admin123', first_name: 'Test', last_name: 'Admin') }
  let!(:regular_user) { create(:user, email: 'user@test.com', password: 'user123', password_confirmation: 'user123', first_name: 'Regular', last_name: 'User') }

  scenario "admin user can sign in and access organizations" do
    visit root_path
    
    # Should be redirected to sign in page
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content("Sign In")
    expect(page).to have_content("Access the Scoreboard Admin Interface")
    
    # Fill in sign in form
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: 'admin123'
    click_button "Sign In"
    
    # Should be redirected to organizations page
    expect(current_path).to eq(admin_organizations_path)
    expect(page).to have_content("Organizations")
    expect(page).to have_content(admin_user.full_name)
    expect(page).to have_link("Sign out")
  end
  
  scenario "regular user cannot access admin interface" do
    visit new_user_session_path
    
    fill_in "Email", with: regular_user.email
    fill_in "Password", with: 'user123'
    click_button "Sign In"
    
    # Regular user should be signed out and redirected back to sign in
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content("Sign In")
  end
  
  scenario "invalid credentials show error" do
    visit new_user_session_path
    
    fill_in "Email", with: "invalid@email.com"
    fill_in "Password", with: "wrongpassword"
    click_button "Sign In"
    
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content("Invalid")
  end
  
  scenario "sign out redirects to sign in page" do
    login_as(admin_user, scope: :user)
    visit admin_organizations_path
    
    expect(page).to have_link("Sign out")
    click_link "Sign out"
    
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content("Sign In")
  end
  
  scenario "accessing admin pages without authentication redirects to sign in" do
    visit admin_organizations_path
    
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content("Sign In")
    expect(page).to have_content("You need to sign in or sign up before continuing")
  end
end
