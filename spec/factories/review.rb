FactoryBot.define do
  factory :review do
    title { Faker::Lorem.sentence }
    review { Faker::Lorem.paragraph }
  end
end