# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Movies", type: :request do
  let(:params) { attributes_for(:movie) }
  let(:movie) { create(:movie) }
  let!(:movie2) { create(:movie) }
  let(:movie_id) { movie.id }

  describe "#create" do
    context "when params are valid" do
      before { post movies_path, params: params }

      it "saves the movie to the database" do
        returned_movie = json["data"]["movie"]
        expect(response).to have_http_status 201
        expect(returned_movie["title"]).to eq params[:title]
        expect(returned_movie["plot"]).to eq params[:plot]
        expect(Movie.last.title).to eq params[:title]
      end
    end

    context "when required attribute is missing" do
      before do
        params.delete(:title)
        post movies_path, params: params
      end

      it "returns an error" do
        expect(response).to have_http_status 422
        expect(json["errors"][0]["title"]).to include "can't be blank"
      end
    end

    context "when title has already been taken" do
      before do
        2.times { post movies_path, params: params }
      end

      it "returns an error" do
        expect(response).to have_http_status 422
        expect(json["errors"][0]["title"]).to include "has already been taken"
      end
    end
  end

  describe "#update" do
    let(:params) { { title: "Edited title" } }

    context "when params are valid" do
      before { patch movie_path(movie_id), params: params }

      it "updates the movie" do
        returned_movie = json["data"]["movie"]
        expect(response).to have_http_status 200
        expect(returned_movie["title"]).to eq params[:title]
      end
    end

    context "when the name to be edited has been taken" do
      before do
        params[:title] = movie2.title
        patch movie_path(movie_id), params: params
      end

      it "returns an error" do
        expect(response).to have_http_status 422
        expect(json["errors"][0]["title"]).to include "has already been taken"
      end
    end
  end

  describe "#show" do
    context "when the id is valid" do
      before { get movie_path(movie_id) }

      it "returns the movie" do
        returned_movie = json["data"]["movie"]
        expect(response).to have_http_status 200
        expect(returned_movie["id"]).to eq movie_id
        expect(returned_movie["title"]).to eq movie.title
      end
    end

    context "when the id is invalid" do
      before { get movie_path(1000) }

      it "returns an error" do
        expect(response).to have_http_status 404
        expect(json["errors"]).to include "Couldn't find Movie"
      end
    end
  end

  describe "#delete" do
    context "when a valid movie is deleted" do
      before { delete movie_path(movie_id) }

      it "updates the deleted_at field" do
        returned_movie = json["data"]["movie"]
        expect(response).to have_http_status 200
        expect(returned_movie["deleted_at"]).to_not be nil
      end
    end

    context "when the id is valid" do
      before { delete movie_path(movie_id) }

      it "returns the movie" do
        returned_movie = json["data"]["movie"]
        expect(response).to have_http_status 200
        expect(returned_movie["id"]).to eq movie_id
        expect(returned_movie["title"]).to eq movie.title
      end
    end
  end

  describe "#index" do
    let!(:movies) { create_list(:movie, 5) }

    context "when a request is made to return the movies" do
      before { get movies_path }

      it "returns the movies in descending order" do
        movie_ids = movies.pluck(:id)
        returned_movie_ids = json["data"]["movies"].first(5).pluck("id")
        expect(response).to have_http_status 200
        expect(Set.new(returned_movie_ids)).to eq(Set.new(movie_ids))
      end
    end
  end
end
