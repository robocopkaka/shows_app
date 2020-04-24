# frozen_string_literal: true

require "rails_helper"

RSpec.describe Season, type: :model do
  describe "presence validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :plot }
    it { should validate_presence_of :number }
  end

  describe "uniqueness validation" do
    subject { build(:season) }

    it {
      should validate_uniqueness_of(:title)
        .scoped_to(:number)
        .case_insensitive
        .with_message("You've already added this title with the number")
    }
  end

  describe "association validations" do
    it { should have_many :episodes }
    it { should have_many :variants }
  end
end
