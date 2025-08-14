class Scoreboard < ApplicationRecord
  belongs_to :game
  
  validates :type, presence: true
  validates :home_score, :visitor_score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :home_timeouts_remaining, :visitor_timeouts_remaining, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }
  
  after_update :broadcast_update
  
  # STI types
  def self.types
    %w[FootballScoreboard BasketballScoreboard SoccerScoreboard]
  end
  
  def sport_name
    type.gsub('Scoreboard', '').downcase
  end
  
  private
  
  def broadcast_update
    ActionCable.server.broadcast(
      "scoreboard_#{game.organization_id}",
      {
        scoreboard: self.as_json(include: {
          game: {
            include: {
              home_team: { methods: [:logo_url] },
              visitor_team: { methods: [:logo_url] }
            }
          }
        })
      }
    )
  end
end
