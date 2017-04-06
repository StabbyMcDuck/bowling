require 'rails_helper'

RSpec.describe(API::V1::PlayersController, type: :routing) do
  describe 'Routing' do
    let(:id) { 1 }

    # Delete
    it "routes DELETE /api/v1/players/:id" do
      expect(
          delete: "/api/v1/players/#{id}"
      ).to route_to action:     "destroy",
                    controller: "api/v1/players",
                    format:     :json,
                    id:         id.to_s
    end

    # Get
    it "routes GET /api/v1/players when game id is given" do
      expect(
          get: "/api/v1/players"
      ).to route_to action:     'index',
                    controller: 'api/v1/players',
                    format:     :json
    end

    it "routes GET /api/v1/players/:id" do
      expect(
          get: "/api/v1/players/#{id}"
      ).to route_to action:     'show',
                    controller: 'api/v1/players',
                    format:     :json,
                    id:         id.to_s
    end

    # Post
    it "does not route Post /api/v1/players" do
      expect(
          post: '/api/v1/players'
      ).to route_to action:     'create',
                    controller: 'api/v1/players',
                    format:     :json
    end

    # Put
    it "does not route PUT /api/v1/players/:id" do
      expect(
          put: "/api/v1/players/#{id}"
      ).to route_to action:     'update',
                    controller: 'api/v1/players',
                    format:     :json,
                    id:         id.to_s

    end
  end
end
