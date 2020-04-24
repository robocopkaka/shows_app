# frozen_string_literal: true

# library model
class Library < ApplicationRecord
  belongs_to :user
  belongs_to :variant

  # scopes
  scope :time_remaining, -> {
    where(created_at: (Time.now - 2.days)..Time.now)
      .order(created_at: :asc)
  }

  # validations
  validate :expired?, on: :create

  def expired?
    show = user.libraries.where(variant_id: variant_id).last
    # return unless current time is less than two days
    # from when the purchased variant was created
    return unless show && Time.now < show.created_at + 2.days

    errors[:base] << "You currently have this show in your library"
  end
end
