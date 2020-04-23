# frozen_string_literal: true

# episodes controller
class EpisodesController < ApplicationController
  before_action :find_season, only: %i[create]
  before_action :find_episode, only: %i[update show destroy]
  before_action :verify_season

  def create
    episode = @season.episodes.create!(episode_params)
    json_response(
      object: episode,
      message: "Episode created successfully",
      status: :created
    )
  end

  def update
    @episode.update!(episode_params)
    json_response(object: @episode, message: "Episode updated successfully")
  end

  def show
    json_response(object: @episode)
  end

  def destroy
    @episode.update!(deleted_at: Time.now)
    json_response(object: @episode)
  end

  private

  def find_season
    @season = Season.find_by!(id: params[:season_id])
  end

  def find_episode
    @episode = Episode.find_by!(id: params[:id])
  end

  def episode_params
    params.permit(:plot, :title, :number)
  end

  # doing this since I'm currently doing soft deletes for show resources
  def verify_season
    find_season
    return if @season.deleted_at.nil?

    render json: { message: "Season no longer available" }, status: 404
  end
end
