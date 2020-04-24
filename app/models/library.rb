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

  #hooks
  # validate :variant_exists?
  validate :expired?, on: :create

  # adding this for now since I'm not sure if I should prevent
  # people from buying different variants of the same show.
  # Can remove if I don't deem necessary
  def variant_exists?
    shows = user.variants.map { |show| [show.showable.id, show.showable_type] }
    show = [variant.showable.id, variant.showable_type]

    return unless show.in?(shows)

    errors.add(:variant, "You already have a variant of this show")
  end

  def expired?
    show = user.libraries.where(variant_id: variant_id).last
    # return unless current time is less than two days
    # from when the purchased variant was created
    return unless show && Time.now < show.created_at + 2.days

    errors[:base] << "You currently have this show in your library"
  end
end
