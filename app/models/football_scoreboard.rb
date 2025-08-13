class FootballScoreboard < Scoreboard
  validates :quarter, presence: true, inclusion: { in: 1..4 }
  validates :time_remaining, presence: true, format: { 
    with: /\A([0-5]?\d):([0-5]\d)\z/, 
    message: "must be in MM:SS format" 
  }
  
  def display_time
    "Q#{quarter} #{time_remaining}"
  end
  
  def overtime?
    quarter > 4
  end
  
  def time_expired?
    time_remaining == "00:00"
  end
end
