FactoryBot.define do
  factory :tenant do
    name { Faker::Name.name }
    trait :free do
      plan { 'free' }
    end
    trait :premium do
      plan { 'premium' }
    end
    description { Faker::Lorem.sentence }
    categories { create_list(:category, 2) }
    statuses { create_list(:status, 5) }
  end
end