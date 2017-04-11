require "rails_helper"

RSpec.describe(API::V1::FramesController, type: :routing) do
  describe 'Routing' do
    let(:id) { 1 }

    # Delete
    it "routes DELETE /api/v1/frames/:id" do
      expect(
          delete: "/api/v1/frames/#{id}"
      ).to route_to action:     "destroy",
                    controller: "api/v1/frames",
                    format:     :json,
                    id:         id.to_s
    end

    # Get
    it "routes GET /api/v1/frames" do
      expect(
          get: "/api/v1/frames"
      ).to route_to action:     'index',
                    controller: 'api/v1/frames',
                    format:     :json
    end

    it "routes GET /api/v1/frames/:id" do
      expect(
          get: "/api/v1/frames/#{id}"
      ).to route_to action:     'show',
                    controller: 'api/v1/frames',
                    format:     :json,
                    id:         id.to_s
    end

    # Post
    it "does not route Post /api/v1/frames" do
      expect(
          post: '/api/v1/frames'
      ).to route_to action:     'create',
                    controller: 'api/v1/frames',
                    format:     :json
    end

    # Put
    it "does not route PUT /api/v1/frames/:id" do
      expect(
          put: "/api/v1/frames/#{id}"
      ).to route_to action:     'update',
                    controller: 'api/v1/frames',
                    format:     :json,
                    id:         id.to_s

    end
  end
end
