require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }
  context "validations" do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end
end
