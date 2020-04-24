# frozen_string_literal: true

# show serializer
class ShowSerializer < ActiveModel::Serializer
  type :show
  attributes :item

  def item
    result = {}
    result[:type] = object.class.to_s
    result[:title] = object.title
    result[:plot] = object.plot

    if object.class.to_s == "Season"
      result[:number] = object.number
      result[:episodes] = ActiveModelSerializers::SerializableResource.new(object.episodes)
    end

    result[:created_at] = object.created_at
    result[:deleted_at] = object.deleted_at

    result
  end
end
