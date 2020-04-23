class Variant < ApplicationRecord
  belongs_to :showable, polymorphic: true
end
