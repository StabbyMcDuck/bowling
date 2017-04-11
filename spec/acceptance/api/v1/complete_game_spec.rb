require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Frame' do
  # PATCH
  patch 'api/v1/frames/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Play a game') do
        client.post '/api/v1/games/'
        expect(status).to eq(201)
        expect(response_body).to include_json({})
        game_id = JSON.parse(response_body).fetch('id')

        client.post '/api/v1/players', {player:{game_id: game_id, name: 'Alice'}}
        expect(status).to eq(201)
        expect(response_body).to include_json(game_id: game_id, name: 'Alice')

        player_id = JSON.parse(response_body).fetch('id')

        # Testing spare bonus
        # Frame 1
        client.post '/api/v1/frames', {frame:{player_id: player_id, first_ball: 6}}
        expect(status).to eq(201)
        expect(response_body).to include_json(frame:{player_id: player_id, number: 1, first_ball: 6, score: 6, bonus: 0, total_score: 6})

        first_frame_id = JSON.parse(response_body).fetch('frame').fetch('id')

        client.patch "/api/v1/frames/#{first_frame_id}", {frame:{second_ball: 4}}
        expect(status).to eq(200)
        expect(response_body).to include_json(frame:{player_id: player_id, first_ball: 6, second_ball: 4, score: 10, bonus: 0, total_score: 10})

        # Frame 2
        client.post '/api/v1/frames', {frame:{player_id: player_id, first_ball: 10}}
        expect(status).to eq(201)
        expect(response_body).to include_json(frame:{player_id: player_id, number: 2, first_ball: 10, score: 10, bonus: 0, total_score: 10})

        second_frame_id = JSON.parse(response_body).fetch('frame').fetch('id')

        client.get "/api/v1/frames/#{first_frame_id}"
        expect(status).to eq(200)
        expect(response_body).to include_json(frame:{player_id: player_id, first_ball: 6, second_ball: 4, score: 10, bonus: 10, total_score: 20})

        # Testing strike bonus (next two rolls are in one frame)
        # Frame 3
        client.post '/api/v1/frames', {frame:{player_id: player_id, first_ball: 6, second_ball: 1}}
        expect(status).to eq(201)
        expect(response_body).to include_json(frame:{player_id: player_id, number: 3, first_ball: 6, second_ball: 1, score: 7, bonus: 0, total_score: 7})

        client.get "/api/v1/frames/#{second_frame_id}"
        expect(status).to eq(200)
        expect(response_body).to include_json(frame:{player_id: player_id, first_ball: 10, score: 10, bonus: 7, total_score: 17})

        # Testing strike bonus (next two rolls are each in a new frame -- strike, strike, no strike )
        # Frame 4
        client.post '/api/v1/frames', {frame:{player_id: player_id, first_ball: 10}}
        expect(status).to eq(201)
        expect(response_body).to include_json(frame:{player_id: player_id, number: 4, first_ball: 10, score: 10, bonus: 0, total_score: 10})

        fourth_frame_id = JSON.parse(response_body).fetch('frame').fetch('id')

        # Frame 5
        client.post '/api/v1/frames', {frame:{player_id: player_id, first_ball: 10}}
        expect(status).to eq(201)
        expect(response_body).to include_json(frame:{player_id: player_id, number: 5, first_ball: 10, score: 10, bonus: 0, total_score: 10})

        # Frame 6
        client.post '/api/v1/frames', {frame:{player_id: player_id, first_ball: 5}}
        expect(status).to eq(201)
        expect(response_body).to include_json(frame:{player_id: player_id, number: 6, first_ball: 5, score: 5, bonus: 0, total_score: 5})

        client.get "/api/v1/frames/#{fourth_frame_id}"
        expect(status).to eq(200)
        expect(response_body).to include_json(frame:{player_id: player_id, first_ball: 10, score: 10, bonus: 10+5, total_score: 10+10+5})

        # Frame 7
        # Bowl less than a spare
        client.post '/api/v1/frames', {frame:{player_id: player_id, first_ball: 3, second_ball: 0}}
        expect(status).to eq(201)
        expect(response_body).to include_json(frame:{player_id: player_id, number: 7, first_ball: 3, score: 3, bonus: 0, total_score: 3})

        # Frame 8
        # Bowl less than a spare
        client.post '/api/v1/frames', {frame:{player_id: player_id, first_ball: 3, second_ball: 0}}
        expect(status).to eq(201)
        expect(response_body).to include_json(frame:{player_id: player_id, number: 8, first_ball: 3, score: 3, bonus: 0, total_score: 3})

        # Frame 9
        # Bowl less than a spare
        client.post '/api/v1/frames', {frame:{player_id: player_id, first_ball: 6, second_ball: 1}}
        expect(status).to eq(201)
        expect(response_body).to include_json(frame:{player_id: player_id, number: 9, first_ball: 6, second_ball: 1, score: 7, bonus: 0, total_score: 7})

        # Frame 10
        # Bowl a strike to check for third ball
        client.post '/api/v1/frames', {frame:{player_id: player_id, first_ball: 10}}
        expect(status).to eq(201)
        expect(response_body).to include_json(frame:{player_id: player_id, number: 10, first_ball: 10, score: 10, bonus: 0, total_score: 10})

        tenth_frame_id = JSON.parse(response_body).fetch('frame').fetch('id')

        client.patch "/api/v1/frames/#{tenth_frame_id}", {frame:{second_ball: 10}}
        expect(status).to eq(200)
        expect(response_body).to include_json(frame:{player_id: player_id, first_ball: 10, second_ball: 10, score: 10, bonus: 10, total_score: 20})

        client.patch "/api/v1/frames/#{tenth_frame_id}", {frame:{third_ball: 10}}
        expect(status).to eq(200)
        expect(response_body).to include_json(frame:{player_id: player_id, first_ball: 10, second_ball: 10, third_ball: 10, score: 10, bonus: 20, total_score: 30})

        # get all frames
        client.get "/api/v1/frames", {player_id: player_id}
        expect(status).to eq(200)
        expect(response_body).to include_json(
                                     [
                                         {
                                             "frame"=>{
                                                 "player_id"=>player_id,
                                                 "number"=>1,
                                                 "first_ball"=>6,
                                                 "second_ball"=>4,
                                                 "bonus"=>10,
                                                 "score"=>10,
                                                 "total_score"=>20
                                             }
                                         },
                                         {
                                             "frame"=>{
                                                 "player_id"=>player_id,
                                                 "number"=>2,
                                                 "first_ball"=>10,
                                                 "second_ball"=>nil,
                                                 "bonus"=>7,
                                                 "score"=>10,
                                                 "total_score"=>17
                                             }
                                         },
                                         {
                                             "frame"=>{
                                                 "player_id"=>player_id,
                                                 "number"=>3,
                                                 "first_ball"=>6,
                                                 "second_ball"=>1,
                                                 "bonus"=>0,
                                                 "score"=>7,
                                                 "total_score"=>7
                                             }
                                         },
                                         {
                                             "frame"=>{
                                                 "player_id"=>player_id,
                                                 "number"=>4,
                                                 "first_ball"=>10,
                                                 "second_ball"=>nil,
                                                 "bonus"=>15,
                                                 "score"=>10,
                                                 "total_score"=>25
                                             }
                                         },
                                         {
                                             "frame"=>{
                                                 "player_id"=>player_id,
                                                 "number"=>5,
                                                 "first_ball"=>10,
                                                 "second_ball"=>nil,
                                                 "bonus"=>5,
                                                 "score"=>10,
                                                 "total_score"=>15
                                             }
                                         },
                                         {
                                             "frame"=>{
                                                 "player_id"=>player_id,
                                                 "number"=>6,
                                                 "first_ball"=>5,
                                                 "second_ball"=>nil,
                                                 "bonus"=>0,
                                                 "score"=>5,
                                                 "total_score"=>5
                                             }
                                         },
                                         {
                                             "frame"=>{
                                                 "player_id"=>player_id,
                                                 "number"=>7,
                                                 "first_ball"=>3,
                                                 "second_ball"=>0,
                                                 "bonus"=>0,
                                                 "score"=>3,
                                                 "total_score"=>3
                                             }
                                         },
                                         {
                                             "frame"=>{
                                                 "player_id"=>player_id,
                                                 "number"=>8,
                                                 "first_ball"=>3,
                                                 "second_ball"=>0,
                                                 "bonus"=>0,
                                                 "score"=>3,
                                                 "total_score"=>3
                                             }
                                         },
                                         {
                                             "frame"=>{
                                                 "player_id"=>player_id,
                                                 "number"=>9,
                                                 "first_ball"=>6,
                                                 "second_ball"=>1,
                                                 "bonus"=>0,
                                                 "score"=>7,
                                                 "total_score"=>7
                                             }
                                         },
                                         {
                                             "frame"=>{
                                                 "player_id"=>player_id,
                                                 "number"=>10,
                                                 "first_ball"=>10,
                                                 "second_ball"=>10,
                                                 "third_ball"=>10,
                                                 "bonus"=>20,
                                                 "score"=>10,
                                                 "total_score"=>30}
                                         }
                                     ]
                                 )
      end

    end
  end
end