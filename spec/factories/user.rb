FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    is_admin { true }
    factory :member do
      first_name { Faker::Internet.first_name }
      last_name { Faker::Internet.last_name }
    end
  end
end
