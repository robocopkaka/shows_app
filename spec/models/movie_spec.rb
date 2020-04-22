# frozen_string_literal: true

require "rails_helper"

RSpec.describe Movie, type: :model do
  describe "presence validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :plot }
  end

  describe "association validations" do
    it { should have_many :variants }
  end

  describe "uniqueness validations" do
    subject { build(:movie) }
    it { should validate_uniqueness_of(:title).case_insensitive }
  end
end
