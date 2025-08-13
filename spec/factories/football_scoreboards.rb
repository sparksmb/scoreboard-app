FactoryBot.define do
  factory :football_scoreboard, parent: :scoreboard do
    type { "FootballScoreboard" }
    quarter { 1 }
    time_remaining { "15:00" }
    
    trait :fourth_quarter do
      quarter { 4 }
      time_remaining { "02:30" }
    end
    
    trait :overtime do
      quarter { 5 }
      time_remaining { "15:00" }
    end
    
    trait :game_over do
      quarter { 4 }
      time_remaining { "00:00" }
    end
  end
end
