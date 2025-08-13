class Team < ApplicationRecord
  belongs_to :organization

  # Games where this team is playing
  has_many :home_games, class_name: 'Game', foreign_key: 'home_team_id', dependent: :restrict_with_error
  has_many :visitor_games, class_name: 'Game', foreign_key: 'visitor_team_id', dependent: :restrict_with_error

  has_one_attached :logo

  validates :name, presence: true, uniqueness: { scope: :organization_id }
  validates :primary_color, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "must be a valid hex color" }, allow_blank: true
  validates :secondary_color, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "must be a valid hex color" }, allow_blank: true

  # Scope for getting all games for this team
  def games
    Game.where('home_team_id = ? OR visitor_team_id = ?', id, id)
  end

  def display_name
    name
  end
end
