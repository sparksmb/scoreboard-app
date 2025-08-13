FactoryBot.define do
  factory :football_scoreboard, class: 'FootballScoreboard' do
    association :game
    home_score { 0 }
    visitor_score { 0 }
    home_timeouts_remaining { 3 }
    visitor_timeouts_remaining { 3 }
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
