# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Libraries", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:movie) { create(:movie) }
  let(:user) { create(:user) }
  let(:variant_id) { movie.variants.last.id }
  let(:user_id) { user.id }
  let(:params) { { variant_id: variant_id } }

  describe "#create" do
    context "when user buys a movie within a time window" do
      before { post user_libraries_path(user_id), params: params }

      it "should add the movie to the library" do
        returned_movie = json["data"]["library"]
        expect(response).to have_http_status 201
        expect(returned_movie["show"]["type"]).to eq "Movie"
        expect(returned_movie["show"]["title"]).to eq movie.title
        expect(returned_movie["show"]["hours_remaining"]).to eq "48 hours"
        expect(Library.last.user_id).to eq user_id
        expect(Library.last.variant_id).to eq variant_id
      end
    end

    context "when user buys a season within a time window" do
      let(:season) { create(:season) }
      let(:season_id) { season_id }
      let(:season_variant_id) { season.variants.last.id }
      let(:params) { { variant_id: season_variant_id } }
      before { post user_libraries_path(user_id), params: params }

      it "should add the season to the library" do
        returned_season = json["data"]["library"]
        expect(response).to have_http_status 201
        expect(returned_season["show"]["type"]).to eq "Season"
        expect(returned_season["show"]["title"]).to eq season.title
        expect(returned_season["show"]). to have_key "episodes"
        expect(Library.last.user_id).to eq user_id
        expect(Library.last.variant_id).to eq season_variant_id
      end
    end

    context "when a user already bought has a movie/season that" do
      context "when they try to buy it again before it's expired" do
        before do
          2.times { post user_libraries_path(user_id), params: params }
        end
        it "returns an error" do
          expect(response).to have_http_status 422
          expect(json["errors"][0]["base"])
            .to include "You currently have this show in your library"
        end
      end

      context "when they try to buy it after it's expired" do
        before { post user_libraries_path(user_id), params: params }

        it "should add the show back to their library" do
          travel 3.days
          expect do
            post user_libraries_path(user_id), params: params
            expect(response).to have_http_status 201
            expect(Library.pluck(:variant_id).uniq).to eq [params[:variant_id]]
          end. to change(Library, :count).by 1
        end
      end
    end
  end

  describe "#index" do
    # let(:movies) { create_list(:movie, 5) }
    let(:movie2) { create(:movie) }
    let(:movie3) { create(:movie) }
    let!(:library) { create(:library, user: user, variant: movie.variants.last) }
    let!(:library2) { create(:library, user: user, variant: movie2.variants.last) }

    context "when a request is made" do
      before do
        travel_to 2.days.ago do
          params[:variant_id] = movie3.variants.last.id
          post user_libraries_path(user_id), params: params
        end
        get user_libraries_path(user_id)
      end
      it "returns shows that the user still has access to" do
        returned_libraries = json["data"]["libraries"]
        expect(response).to have_http_status 200
        expect(returned_libraries.count).to eq 2
      end

      it "should not contain shows older than two days" do
        variant_id = movie3.variants.last.id
        show = Library.where(variant_id: variant_id).first

        expect(json["data"]["libraries"].pluck("id")).to_not include show.id
      end
    end
  end
end
