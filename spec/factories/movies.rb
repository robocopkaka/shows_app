FactoryBot.define do
  factory :movie do
    title { "#{Faker::Name.first_name} - #{Faker::Movie.quote}" }
    plot { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end
