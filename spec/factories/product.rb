FactoryBot.define do
  factory :product do
    code { Faker::Code.name }
    name { Faker::Name.name }
    expected_completion_date { Faker::Date.forward(5) }
    comments { Faker::Lorem.sentence }
  end
end