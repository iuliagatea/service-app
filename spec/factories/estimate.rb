FactoryBot.define do
  factory :estimate do
    name { Faker::Name.name }
    quantity { Faker::Number.within(1..4) }
    price { Faker::Number.between(10, 500) }
  end
end