FactoryBot.define do
  factory :status do
    name { Faker::Name.name }
    color { Faker::Color.hex_color }
  end
end