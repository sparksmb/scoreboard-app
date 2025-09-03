FactoryBot.define do
  factory :football_scoreboard, class: 'FootballScoreboard' do
    association :game
    home_score { 0 }
    visitor_score { 0 }
    home_timeouts_remaining { 3 }
    visitor_timeouts_remaining { 3 }
    quarter { 'Q1' }
    time_remaining { "12:00" }
    
    trait :pre_game do
      quarter { 'PRE' }
      time_remaining { "12:00" }
    end
    
    trait :second_quarter do
      quarter { 'Q2' }
      time_remaining { "08:45" }
    end
    
    trait :halftime do
      quarter { 'HALF' }
      time_remaining { "00:00" }
    end
    
    trait :fourth_quarter do
      quarter { 'Q4' }
      time_remaining { "02:30" }
    end
    
    trait :overtime do
      quarter { 'OT' }
      time_remaining { "15:00" }
    end
    
    trait :game_over do
      quarter { 'FINAL' }
      time_remaining { "00:00" }
    end
  end
end
