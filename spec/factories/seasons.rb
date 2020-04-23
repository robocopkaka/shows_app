FactoryBot.define do
  factory :season do
    title { "MyString" }
    plot { "MyString" }
    sequence(:number)

    transient do
      episodes_count { 5 }
      variants_count { 2 }
    end

    after(:create) do |season, evaluator|
      create_list(:episode, evaluator.episodes_count, season: season)
      # create(:variant, :for_season)
    end

    factory :season_attributes do
      transient do
        episodes_count { 5 }
        variants_count { 2 }
      end

      after(:attributes_for) do |season, evaluator|
        attributes_for(:episode, evaluator.episodes_count, season: season)
      end
    end
  end
end
