require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Player', type: :acceptance do

  let(:name){
    FactoryGirl.create(:name)
  }

  header "Authorization", :authorization

  # DELETE
  delete 'api/v1/players/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('With good ID') do
      let(:id) { player.id }

      example('Deletes player') do
        expect {
          do_request

          expect(status).to eq(204)
          expect(response_body).to be_empty
        }.to change(Player, :count).by(-1)
      end
    end
  end

  # PATCH
  patch 'api/v1/players/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('is Not Found') do
        do_request({player: {name: Faker::RickAndMorty.character }})

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('with good ID') do
      let(:id) { player.id }
      let(:player) { FactoryGirl.create(:player) }

      example('changes name') do
        attributes = {name: Faker::RickAndMorty.character}
        do_request({player: attributes})

        expect(status).to eq(200)
        expect(response_body).to include_json(attributes)

        player_after = Player.find(player.id)

        expect(player_after.name).to eq(attributes[:name])
      end

      example('does not change game associated with player') do
        new_game = FactoryGirl.create(:game)
        do_request({player: { game_id: new_game.id }})

        # unprocessable entity = 422
        expect(status).to eq(422)
        expect(response_body).to include_json({status:422, error:"Unprocessable Entity"})

        player_after = Player.find(player.id)

        expect(player_after.game_id).to eq(player.game_id)
      end
    end
  end

  # POST
  post 'api/v1/players/' do
    example('Player has no name') do
      new_game = FactoryGirl.create(:game)
      do_request({player:{ game_id: new_game.id }})

      expect(status).to eq(422)
      expect(response_body).to include_json({name:["can't be blank"]})
    end

    example('Player has a good name') do
      attributes = { name: Faker::RickAndMorty.character }
      expect{ do_request({player: attributes}) }.to change(Player, :count).by(1)

      expect(status).to eq(201)
      expect(response_body).to include_json(attributes)
    end
  end

  # GET
  get 'api/v1/players' do
    example('Get all players in game when there are no players') do
      new_game = FactoryGirl.create(:game)
      do_request({game_id: new_game.id})

      expect(status).to eq(200)
      expect(response_body).to include_json []
    end

    # so games can't be enumerated (see list of all games)
    example('Error when game id is not given') do
      do_request

      expect(status).to eq(422)
      expect(response_body).to include_json({status: 422, error: "Need game id"})
    end

    example('Get all players with your game id') do
      new_game = FactoryGirl.create(:game)
      player_list = FactoryGirl.create_list(:player, 2, game: new_game)
      do_request({game_id: new_game.id})

      expect(status).to eq(200)
      expect(response_body).to include_json(UnorderedArray(*player_list.map(&:as_json)))
    end
  end

  get 'api/v1/players/:id' do
    context('with bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('with good ID') do
      let(:id) { player.id }
      let(:player) { FactoryGirl.create(:player) }

      example('Shows player') do
        do_request

        expect(status).to eq(200)
        expect(response_body).to include_json(player_json(player))
      end
    end
  end

  private
  def player_json(player)
    {name: player.name, game_id: player.game_id}
  end
end
