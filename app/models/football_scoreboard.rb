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
  
  # Timeout management methods
  def use_home_timeout!
    if home_timeouts_remaining > 0
      update!(home_timeouts_remaining: home_timeouts_remaining - 1)
    else
      errors.add(:home_timeouts_remaining, "No timeouts remaining")
      false
    end
  end
  
  def use_visitor_timeout!
    if visitor_timeouts_remaining > 0
      update!(visitor_timeouts_remaining: visitor_timeouts_remaining - 1)
    else
      errors.add(:visitor_timeouts_remaining, "No timeouts remaining")
      false
    end
  end
  
  # Reset timeouts for each half (optional method for halftime)
  def reset_timeouts_for_half!
    update!(home_timeouts_remaining: 3, visitor_timeouts_remaining: 3)
  end
end
