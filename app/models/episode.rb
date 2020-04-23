# frozen_string_literal: true

# episode model
class Episode < ApplicationRecord
  belongs_to :season, inverse_of: :episodes

  validates_presence_of :title, :plot, :number
  validates :title, uniqueness: {
    scope: :season_id,
    message: "Episode title exists in current season",
    case_sensitive: false
  }
end
