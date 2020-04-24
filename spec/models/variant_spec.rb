# frozen_string_literal: true

require "rails_helper"

RSpec.describe Variant, type: :model do
  describe "association validations" do
    it { should belong_to :showable }
  end
end
