class Game < ApplicationRecord
  belongs_to :organization
  belongs_to :home_team, class_name: 'Team'
  belongs_to :visitor_team, class_name: 'Team'

  has_one :scoreboard, dependent: :destroy

  validates :game_date, presence: true
  validate :teams_must_be_different
  validate :teams_must_belong_to_organization

  scope :upcoming, -> { where('game_date > ?', Time.current) }
  scope :past, -> { where('game_date < ?', Time.current) }
  scope :today, -> { where(game_date: Date.current.beginning_of_day..Date.current.end_of_day) }

  def display_name
    "#{visitor_team.name} vs #{home_team.name}"
  end

  def status
    if game_date.future?
      'upcoming'
    elsif game_date.to_date < Date.current
      'completed'
    else
      'in_progress'
    end
  end

  private

  def teams_must_be_different
    if home_team_id == visitor_team_id
      errors.add(:visitor_team, "cannot be the same as home team")
    end
  end

  def teams_must_belong_to_organization
    if home_team && home_team.organization_id != organization_id
      errors.add(:home_team, "must belong to the same organization")
    end

    if visitor_team && visitor_team.organization_id != organization_id
      errors.add(:visitor_team, "must belong to the same organization")
    end
  end
end
