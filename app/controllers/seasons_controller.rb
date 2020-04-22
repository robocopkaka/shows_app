# frozen_string_literal: true

# seasons controller
class SeasonsController < ApplicationController
  before_action :find_season, only: %i[show update destroy]
  def create
    season = Season.create!(season_params)
    json_response(
      object: season,
      message: "Season created successfully",
      status: :created
    )
  end

  def show
    json_response(object: @season)
  end

  def index
    seasons = Season.descending
    json_response(object: seasons)
  end

  def update
    @season.update!(season_params)
    json_response(object: @season)
  end

  def destroy
    @season.update!(deleted_at: Time.now)
    @season.episodes.each { |episode| episode.update!(deleted_at: Time.now) }
    json_response(object: @season)
  end

  private

  def season_params
    params.permit(
      :plot,
      :title,
      :number,
      episodes_attributes: %i[id plot title number],
      variants_attributes: %i[id plot title number]
    )
  end

  def find_season
    @season = Season.find_by!(id: params[:id])
  end
end
