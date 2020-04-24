# frozen_string_literal: true

# controller for returning all seasons and movies
class AllShowsController < ApplicationController
  before_action :initialize_cache
  def index
    shows = @cache.fetch("all_shows", expires_in: 1.day) do
      movies = Movie.descending.to_a
      seasons = Season.includes(:episodes).descending.to_a

      # feel this could be optimized later if the data set becomes too large
      (movies + seasons).sort_by!(&:created_at)
    end
    render json: shows, each_serializer: ShowSerializer
  end
end
