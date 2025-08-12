require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'associations' do
    it { should have_many(:users).dependent(:destroy) }
  end
  
  describe 'validations' do
    subject { build(:organization) }
    
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_inclusion_of(:active).in_array([true, false]) }
  end
  
  describe 'scopes' do
    let!(:active_org) { create(:organization, active: true) }
    let!(:inactive_org) { create(:organization, active: false) }
    
    describe '.active' do
      it 'returns only active organizations' do
        expect(Organization.active).to contain_exactly(active_org)
      end
    end
  end
  
  describe 'dependent destroy' do
    it 'destroys associated users when organization is destroyed' do
      organization = create(:organization)
      user = create(:user, organization: organization)
      
      expect { organization.destroy }.to change(User, :count).by(-1)
    end
  end
end
