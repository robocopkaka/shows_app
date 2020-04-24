class AllShowsController < ApplicationController
  def index
    movies = Movie.descending
    seasons = Season.descending

    shows = (movies + seasons)
    # feel this could be optimized later if the data set becomes too large
    shows.sort_by!(&:created_at).reverse
    render json: shows, each_serializer: ShowSerializer
  end
end
