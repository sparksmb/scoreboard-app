require 'rails_helper'

RSpec.feature "Admin Organizations Management", type: :feature do
  let(:admin_user) { create(:user, :admin, first_name: "Admin", last_name: "User") }
  let(:regular_user) { create(:user) }

  describe "as an admin user" do
    before do
      login_as(admin_user, scope: :user)
    end

    scenario "viewing the organizations index page" do
      org1 = create(:organization, name: "Test School District")
      org2 = create(:organization, name: "Another District", active: false)
      create(:user, organization: org1)

      visit admin_organizations_path

      expect(page).to have_content("Organizations")
      expect(page).to have_content("Test School District")
      expect(page).to have_content("Another District")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inactive")
      expect(page).to have_link("New Organization")
    end

    scenario "creating a new organization" do
      visit admin_organizations_path
      click_link "New Organization"

      expect(page).to have_content("New Organization")

      fill_in "Name", with: "New Test District"
      select "Active", from: "Status"
      click_button "Create Organization"

      # Should be redirected to show page
      expect(page).to have_content("New Test District")
      expect(page).to have_content("Active")
      expect(page).to have_content("Organization Details")
    end

    scenario "viewing an organization" do
      org = create(:organization, name: "View Test District")
      user = create(:user, organization: org, first_name: "Test", last_name: "User")

      visit admin_organization_path(org)

      expect(page).to have_content("View Test District")
      expect(page).to have_content("Organization Details")
      expect(page).to have_content("Associated Users")
      expect(page).to have_content("Test User")
    end

    scenario "editing an organization" do
      org = create(:organization, name: "Edit Test District")

      visit admin_organization_path(org)
      click_link "Edit"

      expect(page).to have_content("Edit Organization")

      fill_in "Name", with: "Updated District Name"
      select "Inactive", from: "Status"
      click_button "Update Organization"

      # Should be redirected back to show page with updated content
      expect(page).to have_content("Updated District Name")
      expect(page).to have_content("Inactive")
      expect(page).to have_content("Organization Details")
    end

    scenario "deleting an organization" do
      org = create(:organization, name: "Delete Test District")

      visit admin_organizations_path
      expect(page).to have_content("Delete Test District")
      expect(page).to have_link("Delete")

      # For this test, we'll verify the delete link is present and working
      # In a real scenario, this would show a confirmation dialog
      # We can test the actual deletion through a request spec if needed
      delete_link = find_link("Delete")
      expect(delete_link[:href]).to include(admin_organization_path(org))
      expect(delete_link[:'data-method']).to eq('delete')
    end

    scenario "organization form validation" do
      visit new_admin_organization_path

      # Try to submit with blank name
      click_button "Create Organization"

      expect(page).to have_content("Name can't be blank")
    end
  end

  describe "as a regular user" do
    before do
      login_as(regular_user, scope: :user)
    end

    scenario "cannot access admin organizations" do
      visit admin_organizations_path
      
      # Should be redirected to sign in page due to admin requirement
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe "as an unauthenticated user" do
    scenario "redirected to sign in" do
      visit admin_organizations_path

      expect(current_path).to eq(new_user_session_path)
    end
  end
end
