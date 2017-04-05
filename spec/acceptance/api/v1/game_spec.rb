require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Game', type: :acceptance do

  header "Authorization", :authorization

  # DELETE
  delete 'api/v1/games/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('With good ID') do
      let(:id) { game.id }
      let!(:game) { FactoryGirl.create(:game) }

      example('Deletes game') do
        expect {
          do_request

          expect(status).to eq(204)
          expect(response_body).to be_empty
        }.to change(Game, :count).by(-1)
      end
    end
  end

  # GET
  get 'api/v1/games/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('With good ID') do
      let(:id) { game.id }

      let(:game) { FactoryGirl.create(:game) }

      example('Shows game') do
        do_request

        expect(status).to eq(200)
        expect(response_body).to include_json(game_json(game))
      end
    end
  end

  # PATCH
  patch 'api/v1/games/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('is Not Found') do
        do_request({ game: { id: SecureRandom.uuid } })

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end
  end

  # POST
  post 'api/v1/games/' do
    example('Create a game') do
      expect{ do_request({game: {}}) }.to change(Game, :count).by(1)

      expect(status).to eq(201)
      expect(response_body).to include_json({})
    end
  end

  private
  def valid_attributes
    {}
  end

  def game_json(game)
    {id: game.id}
  end
end
