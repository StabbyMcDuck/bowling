module FramesHelper
  def bonus(frame)
    first_ball = frame.first_ball || 0
    second_ball = frame.second_ball || 0

    if first_ball == 10
      strike_bonus(frame)
    elsif first_ball + second_ball == 10
      spare_bonus(frame)
    else
      0
    end
  end

  def strike_bonus(frame)
    # strike bonus = 10 + next two rolls
    bonus = 0
    frames = Frame.where(player_id: frame.player_id, number: [frame.number + 1, frame.number + 2]).order(number: :asc)

    bonus += frames.first.first_ball

    if frames.first.first_ball == 10
      bonus += frames.second.first_ball
    else
      bonus += frames.first.second_ball
    end

    bonus
  end

  def spare_bonus(frame)
    # spare bonus = 10 + next one roll
    bonus = 0
    frames = Frame.where(player_id: frame.player_id, number: [frame.number + 1])

    bonus += frames.first.first_ball

    bonus
  end

  def score(frame)
    first_ball = frame.first_ball || 0
    second_ball = frame.second_ball || 0

    first_ball + second_ball
  end
end
