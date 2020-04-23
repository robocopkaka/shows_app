# frozen_string_literal: true

# library serializer
class LibrarySerializer < ActiveModel::Serializer
  attributes :id, :show

  def show
    result = {}
    result[:type] = object.variant.showable_type
    result[:title] = object.variant.showable.title
    result[:plot] = object.variant.showable.plot
    result[:quality] = object.variant.quality
    result[:cost] = object.variant.cost
    result[:hours_remaining] = "#{hours_remaining(object.created_at)} hours"
    result[:date_added] = object.created_at

    if object.variant.showable_type == "Season"
      result[:number] = object.variant.showable.number
      result[:episodes] = object.variant.showable.episodes
    end

    result
  end

  def hours_remaining(time)
    ((time + 2.days) - Time.now).ceil.to_i / 3600
  end
end
