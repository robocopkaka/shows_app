# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

10.times do
  name = "#{Faker::Name.first_name}.#{Faker::Name.last_name}"
  User.create!(email: "#{name}@test.com")
end

10.times do
  # create movies
  title = "#{Faker::Name.first_name} - #{Faker::Movie.quote}"
  plot = Faker::Lorem.paragraph(sentence_count: 3)

  Movie.create!(plot: plot, title: title)
end

10.times do |num|
  # create movies
  title = "#{Faker::Name.first_name} - #{Faker::Movie.quote}"
  plot = Faker::Lorem.paragraph(sentence_count: 3)

  Movie.create!(plot: plot, title: title)
end

Season.all.each do |season|
  3.times do |num|
    title = "#{Faker::Name.first_name} - #{Faker::Name.rand(1000)}"
    plot = Faker::Lorem.paragraph(sentence_count: 3)
    season.episodes.create!(plot: plot, title: title, number: num)
  end
end