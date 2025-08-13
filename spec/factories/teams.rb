FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    sequence(:mascot) { |n| "Mascot #{n}" }
    primary_color { "#FF0000" }
    secondary_color { "#FFFFFF" }
    association :organization
    
    trait :with_logo do
      after(:build) do |team|
        team.logo.attach(
          io: StringIO.new("fake image data"),
          filename: "logo.png",
          content_type: "image/png"
        )
      end
    end
  end
end
