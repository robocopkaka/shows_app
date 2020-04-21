# frozen_string_literal: true

# users controller
class UsersController < ApplicationController
  def create
    user = User.create!(user_params)
    json_response(object: user, message: "User created successfully")
  end

  private

  def user_params
    params.permit(:email)
  end
end
