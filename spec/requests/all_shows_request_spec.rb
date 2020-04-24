require 'rails_helper'

RSpec.describe "AllShows", type: :request do
  let!(:season) { create(:season) }
  let!(:movie) { create(:movie) }
  let!(:season2) { create(:season) }
  let!(:movie2) { create(:movie) }
  describe "GET /index" do
    context "when a request is made" do
      before { get all_shows_path }

      it "returns all movies and seasons" do
        returned_shows = json["shows"]
        times = returned_shows.pluck("item").pluck("created_at")
        expect(response).to have_http_status(200)
        expect(returned_shows.count).to eq 4
        expect(times[0]).to be < times[1]
        expect(times[2]).to be < times[3]
      end
    end
  end

end
