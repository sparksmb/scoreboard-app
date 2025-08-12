require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to(:organization).optional }
  end
  
  describe 'validations' do
    subject { build(:user) }
    
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_inclusion_of(:admin).in_array([true, false]) }
    
    context 'when user is not an admin' do
      it { should validate_presence_of(:organization_id) }
    end
    
    context 'when user is an admin' do
      subject { build(:user, :admin) }
      
      it { should_not validate_presence_of(:organization_id) }
    end
  end
  
  describe 'scopes' do
    let!(:admin_user) { create(:user, :admin) }
    let!(:regular_user) { create(:user) }
    let!(:inactive_org) { create(:organization, active: false) }
    let!(:user_in_inactive_org) { create(:user, organization: inactive_org) }
    
    describe '.admins' do
      it 'returns only admin users' do
        expect(User.admins).to contain_exactly(admin_user)
      end
    end
    
    describe '.non_admins' do
      it 'returns only non-admin users' do
        expect(User.non_admins).to contain_exactly(regular_user, user_in_inactive_org)
      end
    end
    
    describe '.active' do
      it 'returns only users from active organizations' do
        expect(User.active).to contain_exactly(regular_user)
      end
    end
  end
  
  describe '#full_name' do
    it 'returns first and last name combined' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end
  
  describe '#admin?' do
    it 'returns true for admin users' do
      user = build(:user, :admin)
      expect(user.admin?).to be true
    end
    
    it 'returns false for non-admin users' do
      user = build(:user)
      expect(user.admin?).to be false
    end
  end
  
  describe '#can_access_organization?' do
    let(:organization) { create(:organization) }
    let(:other_organization) { create(:organization) }
    
    context 'when user is an admin' do
      let(:admin_user) { create(:user, :admin) }
      
      it 'can access any organization' do
        expect(admin_user.can_access_organization?(organization.id)).to be true
        expect(admin_user.can_access_organization?(other_organization.id)).to be true
      end
    end
    
    context 'when user is not an admin' do
      let(:user) { create(:user, organization: organization) }
      
      it 'can only access their own organization' do
        expect(user.can_access_organization?(organization.id)).to be true
        expect(user.can_access_organization?(other_organization.id)).to be false
      end
    end
  end
end
