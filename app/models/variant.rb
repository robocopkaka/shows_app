class Variant < ApplicationRecord
  belongs_to :showable, polymorphic: true

  has_many :libraries
  has_many :users, through: :libraries
end
