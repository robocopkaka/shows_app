# frozen_string_literal: true

# movies controller
class MoviesController < ApplicationController
  before_action :initialize_cache
  after_action :invalidate_index_cache, only: %i[create update destroy]
  before_action :find_movie, only: %i[show update destroy]

  def create
    movie = Movie.create!(movie_params)
    json_response(
      object: movie,
      message: "Movie created successfully",
      status: :created
    )
  end

  def show
    json_response(object: @movie)
  end

  def index
    movies = @cache.fetch("movie_index", expires_in: 10.minute) do
      Movie.descending.to_a
    end
    json_response(object: movies)
  end

  def update
    @movie.update!(movie_params)
    json_response(object: @movie)
  end

  def destroy
    @movie.update!(deleted_at: Time.now)
    json_response(object: @movie)
  end

  private

  def movie_params
    params.permit(:plot, :title)
  end

  def find_movie
    @movie = Movie.find_by!(id: params[:id])
  end

  def invalidate_index_cache
    invalidate_cache("movie_index")
  end
end
