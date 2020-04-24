require 'rails_helper'

RSpec.describe "Seasons", type: :request do
  let(:season) { create(:season) }
  let(:season_id) { season.id }


  describe "#create" do
    let(:params) do
      attributes_for(:season_attributes)
        .merge(episodes_attributes: attributes_for_list(:episode, 3))
    end

    context "when params are valid" do
      before { post seasons_path, params: params }
      it "saves the season with episodes" do
        returned_season = json["data"]["season"]
        expect(response).to have_http_status 201
        expect(returned_season["plot"]).to eq params[:plot]
        expect(returned_season["episodes"].count)
          .to eq params[:episodes_attributes].count

        db_episode_season_id = Season.last.episodes.pluck(:season_id).uniq
        returned_episode_season_id = returned_season["episodes"]
                                     .pluck("season_id").uniq
        expect(db_episode_season_id).to eq returned_episode_season_id
      end

      it "creates variants for the season" do
        variants = Variant.where(showable_id: Season.last.id)
        expect(variants.count).to eq 2
        expect(variants.pluck(:quality)).to include "HD"
        expect(variants.pluck(:quality)).to include "SD"
      end
    end

    context "when the season name name and number have been taken" do
      before do
        2.times { post seasons_path, params: params }
      end

      it "returns an error" do
        expect(response).to have_http_status 422
        expect(json["errors"][0]["title"])
          .to include "You've already added this title with the number"
      end
    end

    context "when validation fails for an episode" do
      before do
        params[:episodes_attributes].first.delete(:title)
        post seasons_path, params: params
      end
      it "doesn't save the episode" do
        returned_episodes = json["data"]["season"]["episodes"]
        expect(response).to have_http_status 201
        expect(returned_episodes.count).to eq 2 # original number of episodes is 3
      end
    end
  end

  describe "#update" do
    let!(:season2) { create(:season) }

    let(:params)  { { title: "Updated title" } }
    context "when the params are valid" do
      before { patch season_path(season_id), params: params }
      it "updates the season" do
        returned_season = json["data"]["season"]
        expect(response).to have_http_status 200
        expect(returned_season["title"]).to eq params[:title]
      end
    end

    context "when the name has already been" do
      before do
        params[:title] = season2.title
        params[:number] = season2.number
        patch season_path(season_id), params: params
      end

      it "returns an error" do
        expect(response).to have_http_status 422
        expect(json["errors"][0]["title"])
          .to include "You've already added this title with the number"
      end
    end

    context "when an invalid id is passed" do
      before { patch season_path(1000), params: params }

      it "returns an error" do
        expect(response).to have_http_status 404
        expect(json["errors"]).to include "Couldn't find Season"
      end
    end
  end

  describe "#show" do
    context "when the id is valid" do
      before { get season_path(season_id) }

      it "returns the season" do
        returned_season = json["data"]["season"]
        expect(response).to have_http_status 200
        expect(returned_season["title"]).to eq season.title
        expect(returned_season["plot"]).to eq season.plot
      end
    end

    context "when the id is invalid" do
      before { get season_path(1000) }

      it "returns an error" do
        expect(response).to have_http_status 404
        expect(json["errors"]).to include "Couldn't find Season"
      end
    end
  end

  describe "#delete" do
    context "when the id is valid" do
      before { delete season_path(season_id) }

      it "soft deletes the season" do
        returned_season = json["data"]["season"]
        returned_episodes = json["data"]["season"]["episodes"]
        expect(response).to have_http_status 200
        expect(returned_season["deleted_at"]).to_not be nil
        expect(returned_episodes.pluck("deleted_at")).to_not include nil
      end
    end

    context "when the id is invalid" do
      before { delete season_path(1000) }

      it "returns an error" do
        expect(response).to have_http_status 404
        expect(json["errors"]).to include "Couldn't find Season"
      end
    end
  end

  describe "#index" do
    let!(:seasons) { create_list(:season, 5) }

    context "when a request is made to return all seasons" do
      before { get seasons_path }
      it " returns all seasons ordered by creation" do
        returned_seasons = json["data"]["seasons"]
        expect(response).to have_http_status 200
        expect(returned_seasons.count).to eq 5
        first_season = DateTime.parse(returned_seasons.first["created_at"])
        second_season = DateTime.parse(returned_seasons[1]["created_at"])
        # showing newer seasons first
        expect(first_season).to be > second_season
      end
    end
  end
end
