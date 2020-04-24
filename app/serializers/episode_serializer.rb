# frozen_string_literal: true

# episodes serializer
class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :plot, :title, :number, :season_id, :deleted_at
end
