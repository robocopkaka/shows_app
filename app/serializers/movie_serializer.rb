# frozen_string_literal: true

# movie serializer
class MovieSerializer < ActiveModel::Serializer
  attributes :id, :plot, :title, :created_at, :deleted_at
end
