FactoryBot.define do
  factory :game do
    association :organization
    game_date { 1.week.from_now }
    location { "Stadium" }
    description { "Regular season game" }
    
    # Create teams after build to ensure same organization and different names
    after(:build) do |game|
      unless game.home_team
        game.home_team = create(:team, organization: game.organization, name: "Home Team #{SecureRandom.hex(4)}")
      end
      unless game.visitor_team
        game.visitor_team = create(:team, organization: game.organization, name: "Visitor Team #{SecureRandom.hex(4)}")
      end
    end
    
    trait :with_scoreboard do
      after(:create) do |game|
        create(:football_scoreboard, game: game)
      end
    end
    
    trait :today do
      game_date { Time.current }
    end
    
    trait :past do
      game_date { 1.week.ago }
    end
  end
end
