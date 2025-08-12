class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  belongs_to :organization, optional: true
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :admin, inclusion: { in: [true, false] }
  validates :organization_id, presence: true, unless: :admin?
  
  scope :admins, -> { where(admin: true) }
  scope :non_admins, -> { where(admin: false) }
  scope :active, -> { joins(:organization).where(organizations: { active: true }) }
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def admin?
    admin
  end
  
  def can_access_organization?(org_id)
    return true if admin?
    organization_id == org_id
  end
end
