class User < ApplicationRecord
  validates_uniqueness_of :email
  validates_presence_of :email

  has_many :libraries
  has_many :variants, through: :libraries
end
