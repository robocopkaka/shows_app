# frozen_string_literal: true

# movies controller
class MoviesController < ApplicationController
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
    movies = Movie.descending
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
end
