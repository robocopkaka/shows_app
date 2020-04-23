# frozen_string_literal: true

# season model
class Season < ApplicationRecord
  include CreateVariant

  validates_presence_of :title, :plot, :number
  validates :title, uniqueness: {
    scope: :number,
    message: "You've already added this title with the number",
    case_sensitive: false
  }

  # scopes
  scope :descending, -> { order(created_at: :desc) }

  # associations
  has_many :variants, as: :showable
  has_many :episodes, -> { order "number ASC" }, inverse_of: :season
  accepts_nested_attributes_for :episodes, reject_if: :reject_episodes
  accepts_nested_attributes_for :variants

  # hooks
  after_create :create_variants

  private

  def reject_episodes(attributes)
    attributes[:title].blank?
  end
end
