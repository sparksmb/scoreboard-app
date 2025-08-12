FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    admin { false }
    association :organization
    
    trait :admin do
      admin { true }
      organization { nil }
    end
  end
end
