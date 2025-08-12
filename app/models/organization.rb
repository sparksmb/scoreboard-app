class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :active, inclusion: { in: [true, false] }
  
  scope :active, -> { where(active: true) }
end
