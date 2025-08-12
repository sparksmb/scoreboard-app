require 'rails_helper'

RSpec.describe "Admin::Organizations", type: :request do
  include Devise::Test::IntegrationHelpers
  
  let!(:admin_user) { create(:user, :admin, email: 'admin@test.com') }
  let!(:regular_user) { create(:user, email: 'user@test.com') }
  let!(:organization) { create(:organization, name: 'Test Organization') }

  describe "DELETE /admin/organizations/:id" do
    context "when signed in as admin" do
      before do
        sign_in admin_user
      end

      it "deletes the organization and redirects to index" do
        expect {
          delete admin_organization_path(organization)
        }.to change(Organization, :count).by(-1)

        expect(response).to redirect_to(admin_organizations_path)
        follow_redirect!
        expect(response.body).to include("Organization was successfully deleted")
      end

      it "deletes associated users when deleting organization" do
        user1 = create(:user, organization: organization, first_name: 'User1', last_name: 'Test')
        user2 = create(:user, organization: organization, first_name: 'User2', last_name: 'Test')

        expect {
          delete admin_organization_path(organization)
        }.to change(Organization, :count).by(-1)
          .and change(User, :count).by(-2)  # Both users should be deleted

        expect(response).to redirect_to(admin_organizations_path)
      end
    end

    context "when signed in as regular user" do
      before do
        sign_in regular_user
      end

      it "redirects to sign in page" do
        delete admin_organization_path(organization)
        expect(response).to redirect_to(new_user_session_path)
        expect(Organization.exists?(organization.id)).to be true  # Should not be deleted
      end
    end

    context "when not signed in" do
      it "redirects to sign in page" do
        delete admin_organization_path(organization)
        expect(response).to redirect_to(new_user_session_path)
        expect(Organization.exists?(organization.id)).to be true  # Should not be deleted
      end
    end
  end

  describe "POST /admin/organizations" do
    context "when signed in as admin" do
      before do
        sign_in admin_user
      end

      it "creates a new organization with valid parameters" do
        expect {
          post admin_organizations_path, params: { 
            organization: { name: 'New Organization', active: true } 
          }
        }.to change(Organization, :count).by(1)

        expect(response).to redirect_to(admin_organization_path(Organization.last))
        follow_redirect!
        expect(response.body).to include("Organization was successfully created")
        expect(response.body).to include("New Organization")
      end

      it "does not create organization with invalid parameters" do
        expect {
          post admin_organizations_path, params: { 
            organization: { name: '', active: true } 
          }
        }.not_to change(Organization, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Name can&#39;t be blank")
      end
    end
  end

  describe "PATCH/PUT /admin/organizations/:id" do
    context "when signed in as admin" do
      before do
        sign_in admin_user
      end

      it "updates organization with valid parameters" do
        patch admin_organization_path(organization), params: { 
          organization: { name: 'Updated Name', active: false } 
        }

        organization.reload
        expect(organization.name).to eq('Updated Name')
        expect(organization.active?).to be false

        expect(response).to redirect_to(admin_organization_path(organization))
        follow_redirect!
        expect(response.body).to include("Organization was successfully updated")
        expect(response.body).to include("Updated Name")
      end

      it "does not update with invalid parameters" do
        original_name = organization.name
        patch admin_organization_path(organization), params: { 
          organization: { name: '' } 
        }

        organization.reload
        expect(organization.name).to eq(original_name)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Name can&#39;t be blank")
      end
    end
  end
end
