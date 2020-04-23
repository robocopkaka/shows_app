# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Episodes", type: :request do
  let(:season) { create(:season) }
  let(:season_id) { season.id }
  let(:episode) { create(:episode) }
  let(:episode_id) { episode.id }
  let(:params) { attributes_for(:episode) }
  describe "#create" do
    context "when params are valid" do
      before { post season_episodes_path(season_id), params: params }

      it "creates the episode" do
        returned_episode = json["data"]["episode"]
        expect(response).to have_http_status 201
        expect(returned_episode["title"]).to eq params[:title]
        expect(Episode.last.title).to eq params[:title]
      end
    end

    context "when the title has been taken in a season" do
      before do
        2.times { post season_episodes_path(season_id), params: params }
      end

      it "returns an error" do
        expect(response).to have_http_status 422
        expect(json["errors"][0]["title"])
          .to include "Episode title exists in current season"
      end
    end

    context "if season id is invalid" do
      before { post season_episodes_path(1000), params: params }

      it "returns an error" do
        expect(response).to have_http_status 404
        expect(json["errors"]).to include "Couldn't find Season"
      end
    end
  end

  describe "#update" do
    let(:params) { { title: "Updated title" } }
    context "when params are valid" do
      before do
        patch season_episode_path(season_id: season_id, id: episode_id),
              params: params
      end

      it "updates the episode" do
        returned_episode = json["data"]["episode"]
        expect(response).to have_http_status 200
        expect(returned_episode["title"]).to eq params[:title]
      end
    end

    context "when episode id is invalid" do
      before do
        patch season_episode_path(season_id: season_id, id: 1000),
              params: params
      end

      it "returns an error do" do
        expect(response).to have_http_status 404
        expect(json["errors"]).to include "Couldn't find Episode"
      end
    end
  end

  describe "#show" do
    context "when episode id is valid" do
      before do
        get season_episode_path(season_id: season_id, id: episode_id)
      end
      it "returns the episode" do
        returned_episode = json["data"]["episode"]
        expect(response).to have_http_status 200
        expect(returned_episode["title"]).to eq episode[:title]
      end
    end

    context "when episode id is invalid" do
      before do
        get season_episode_path(season_id: season_id, id: 1000)
      end
      it "returns an error" do
        expect(response).to have_http_status 404
        expect(json["errors"]).to include "Couldn't find Episode"
      end
    end
  end

  describe "#delete" do
    context "when episode id is valid" do
      before do
        delete season_episode_path(season_id: season_id, id: episode_id)
      end
      it "soft deletes the episode" do
        returned_episode = json["data"]["episode"]
        expect(response).to have_http_status 200
        expect(returned_episode["deleted_at"]).to_not be nil
      end
    end

    context "when episode id is invalid" do
      before do
        delete season_episode_path(season_id: season_id, id: 1000)
      end
      it "returns an error" do
        expect(response).to have_http_status 404
        expect(json["errors"]).to include "Couldn't find Episode"
      end
    end
  end

  describe "season soft deleted" do
    context "when the season has been deleted" do
      before do
        delete season_path(season_id)
        get season_episode_path(season_id: season_id, id: episode_id)
      end

      it "returns an error message" do
        expect(response).to have_http_status 404
        expect(json["message"]).to eq "Season no longer available"
      end
    end
  end
end
