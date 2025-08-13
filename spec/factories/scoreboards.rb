FactoryBot.define do
  factory :scoreboard do
    association :game
    type { "FootballScoreboard" }
    home_score { 0 }
    visitor_score { 0 }
  end
end
