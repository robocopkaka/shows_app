# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersController, type: :request do
  let(:params) { attributes_for :user }

  describe "POST /users" do
    context "when params are valid" do
      before { post users_path, params: params }
      it "creates the user" do
        user = json["data"]["user"]
        expect(json["message"]).to eq "User created successfully"
        expect(user["email"]).to eq params[:email]
      end
    end

    context "when email has already been added" do
      before { post users_path, params: params }
      it "returns an error" do
        expect do
          post users_path, params: params
        end.to raise_exception ActiveRecord::RecordInvalid
      end
    end

    context "when email is empty" do
      it "returns an error" do
        expect do
          post users_path, params: {}
        end.to raise_exception ActiveRecord::RecordInvalid
      end
    end
  end
end
