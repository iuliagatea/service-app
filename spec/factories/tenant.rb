FactoryBot.define do
  factory :tenant do
    name { Faker::Name.name }
    plan { 'free' }
    description { Faker::Lorem.sentence }
    categories { create_list(:category, 2) }
    statuses { create_list(:status, 5) }
  end
  # factory :premium_tenant do
  #   create(:tenant, plan: 'premium')
  # end
end