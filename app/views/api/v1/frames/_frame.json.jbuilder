json.url api_v1_frame_url(frame, format: :json)
json.frame do
  json.id frame.id
  json.player_id frame.player_id
  json.number frame.number
  json.first_ball frame.first_ball
  json.second_ball frame.second_ball
  json.created_at frame.created_at
  json.updated_at frame.updated_at
  bonus = bonus(frame)
  score = score(frame)
  json.bonus bonus
  json.score score
  json.total_score bonus + score

end

