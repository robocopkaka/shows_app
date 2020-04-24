# frozen_string_literal: true

# movie model
class Movie < ApplicationRecord
  include CreateVariant
  validates_presence_of :title, :plot
  validates_uniqueness_of :title, case_sensitive: false

  has_many :variants, as: :showable

  #scopes
  scope :not_nil, -> { where(deleted_at: nil) }
  scope :descending, -> { order(created_at: :desc) }

  #hooks
  after_create :create_variants
end
