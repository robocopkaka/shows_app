# frozen_string_literal: true

require "rails_helper"

RSpec.describe Episode, type: :model do
  describe "presence validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :plot }
    it { should validate_presence_of :number }
  end

  describe "uniqueness validation" do
    subject { build(:episode) }

    it {
      should validate_uniqueness_of(:title)
        .scoped_to(:season_id)
        .case_insensitive
        .with_message("Episode title exists in current season")
    }
  end

  describe "association validations" do
    it { should belong_to :season }
  end
end
