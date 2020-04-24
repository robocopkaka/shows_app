class SeasonSerializer < ActiveModel::Serializer
  attributes :id, :plot, :title, :number, :created_at, :deleted_at

  has_many :episodes
end
