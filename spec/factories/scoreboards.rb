FactoryBot.define do
  factory :scoreboard do
    association :game
    type { "FootballScoreboard" }
    home_score { 0 }
    visitor_score { 0 }
    home_timeouts_remaining { 3 }
    visitor_timeouts_remaining { 3 }
    quarter { 1 }
    time_remaining { "15:00" }
  end
end
