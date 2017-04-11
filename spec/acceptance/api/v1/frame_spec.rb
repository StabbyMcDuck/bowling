require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Frame', type: :acceptance do

  header "Authorization", :authorization

  # GET
  get 'api/v1/frames/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('With good ID') do
      let(:id) { frame.id }

      let(:frame) { FactoryGirl.create(:frame) }

      example('Shows frame') do
        do_request

        expect(status).to eq(200)
        expect(response_body).to include_json(frame_json(frame))
      end
    end
  end

  # PATCH
  patch 'api/v1/frames/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('is Not Found') do
        do_request({ frame: { id: SecureRandom.uuid } })

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end
  end

  # POST
  post 'api/v1/frames/' do
    let(:player) { FactoryGirl.create(:player) }
    example('Create a frame') do
      expect{ do_request({frame: {player_id: player.id}}) }.to change(Frame, :count).by(1)

      expect(status).to eq(201)
      expect(response_body).to include_json({})
    end
  end

  private
  def valid_attributes
    {}
  end

  def frame_json(frame)
    {frame:{id: frame.id, number: frame.number, first_ball: frame.first_ball, second_ball: frame.second_ball, bonus: ( be >= 0), score: ((frame.first_ball || 0) + (frame.second_ball || 0)), total_score: ( be >= 0) }}
  end
end
