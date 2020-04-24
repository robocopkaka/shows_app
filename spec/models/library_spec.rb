# frozen_string_literal: true

require "rails_helper"

RSpec.describe Library, type: :model do
  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :variant }
  end
end
