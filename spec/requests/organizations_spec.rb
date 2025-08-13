require 'rails_helper'

RSpec.describe "Organizations", type: :request do
  include Devise::Test::IntegrationHelpers
  
  let!(:admin_user) { create(:user, :admin, email: 'admin@test.com') }
  let!(:regular_user) { create(:user, email: 'user@test.com') }
  let!(:organization) { create(:organization, name: 'Test Organization') }

  describe "DELETE /organizations/:id" do
    context "when signed in as admin" do
      before do
        sign_in admin_user
      end

      it "deletes the organization and redirects to index" do
        expect {
          delete organization_path(organization)
        }.to change(Organization, :count).by(-1)

        expect(response).to redirect_to(organizations_path)
        follow_redirect!
        expect(response.body).to include("Organization was successfully deleted")
      end

      it "deletes associated users when deleting organization" do
        user1 = create(:user, organization: organization, first_name: 'User1', last_name: 'Test')
        user2 = create(:user, organization: organization, first_name: 'User2', last_name: 'Test')

        expect {
          delete organization_path(organization)
        }.to change(Organization, :count).by(-1)
          .and change(User, :count).by(-2)  # Both users should be deleted

        expect(response).to redirect_to(organizations_path)
      end
    end

    context "when signed in as regular user" do
      before do
        sign_in regular_user
      end

      it "redirects with access denied" do
        delete organization_path(organization)
        expect(response).to redirect_to(root_path)
        expect(Organization.exists?(organization.id)).to be true  # Should not be deleted
      end
    end

    context "when not signed in" do
      it "redirects to sign in page" do
        delete organization_path(organization)
        expect(response).to redirect_to(new_user_session_path)
        expect(Organization.exists?(organization.id)).to be true  # Should not be deleted
      end
    end
  end

  describe "POST /organizations" do
    context "when signed in as admin" do
      before do
        sign_in admin_user
      end

      it "creates a new organization with valid parameters" do
        expect {
          post organizations_path, params: { 
            organization: { name: 'New Organization', active: true } 
          }
        }.to change(Organization, :count).by(1)

        expect(response).to redirect_to(organization_path(Organization.last))
        follow_redirect!
        expect(response.body).to include("Organization was successfully created")
        expect(response.body).to include("New Organization")
      end

      it "does not create organization with invalid parameters" do
        expect {
          post organizations_path, params: { 
            organization: { name: '', active: true } 
          }
        }.not_to change(Organization, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Name can&#39;t be blank")
      end
    end
  end

  describe "PATCH/PUT /organizations/:id" do
    context "when signed in as admin" do
      before do
        sign_in admin_user
      end

      it "updates organization with valid parameters" do
        patch organization_path(organization), params: { 
          organization: { name: 'Updated Name', active: false } 
        }

        organization.reload
        expect(organization.name).to eq('Updated Name')
        expect(organization.active?).to be false

        expect(response).to redirect_to(organization_path(organization))
        follow_redirect!
        expect(response.body).to include("Organization was successfully updated")
        expect(response.body).to include("Updated Name")
      end

      it "does not update with invalid parameters" do
        original_name = organization.name
        patch organization_path(organization), params: { 
          organization: { name: '' } 
        }

        organization.reload
        expect(organization.name).to eq(original_name)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Name can&#39;t be blank")
      end
    end

    context "when signed in as regular user" do
      before do
        regular_user.update!(organization: organization)
        sign_in regular_user
      end

      it "can update their own organization" do
        patch organization_path(organization), params: { 
          organization: { name: 'Updated by Regular User', active: false } 
        }

        organization.reload
        expect(organization.name).to eq('Updated by Regular User')
        expect(organization.active?).to be false

        expect(response).to redirect_to(organization_path(organization))
      end

      it "cannot update another organization" do
        other_organization = create(:organization, name: 'Other Org')
        original_name = other_organization.name
        
        patch organization_path(other_organization), params: { 
          organization: { name: 'Hacked Name' } 
        }

        other_organization.reload
        expect(other_organization.name).to eq(original_name)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /organizations (index)" do
    context "when signed in as admin" do
      before do
        sign_in admin_user
      end

      it "shows all organizations" do
        get organizations_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when signed in as regular user with organization" do
      before do
        regular_user.update!(organization: organization)
        sign_in regular_user
      end

      it "redirects to their organization" do
        get organizations_path
        expect(response).to redirect_to(organization_path(organization))
      end
    end

  end

  describe "GET /organizations/:id (show)" do
    context "when signed in as regular user" do
      before do
        regular_user.update!(organization: organization)
        sign_in regular_user
      end

      it "can view their own organization" do
        get organization_path(organization)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(organization.name)
      end

      it "cannot view another organization" do
        other_organization = create(:organization, name: 'Other Org')
        
        get organization_path(other_organization)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /organizations/new" do
    context "when signed in as regular user" do
      before do
        sign_in regular_user
      end

      it "redirects with access denied" do
        get new_organization_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
