# frozen_string_literal: true

# libraries controller
class LibrariesController < ApplicationController
  before_action :find_user
  def create
    library = @user.libraries.create!(library_params)
    json_response(
      object: library,
      message: "Show added to library",
      status: :created
    )
  end

  def index
    libraries = @user.libraries.time_remaining
    json_response(object: libraries)
  end

  private

  def library_params
    params.permit(:variant_id)
  end

  def find_user
    @user = User.find_by!(id: params[:user_id])
  end
end
