FactoryBot.define do
  factory :episode do
    title { "#{Faker::Name.first_name} - #{Faker::Name.rand(1000)}" }
    plot { "MyString" }
    sequence(:number)
    season
  end
end
