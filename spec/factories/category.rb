FactoryBot.define do
  factory :category do
    entity { 'tenant' }
    name { Faker::Name.name }
  end
end