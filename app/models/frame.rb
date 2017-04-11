class Frame < ApplicationRecord
  belongs_to :player

  #validations
  validates :player, presence: true
  validates :number, numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates :first_ball, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true, allow_nil: true }
  validates :second_ball, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true, allow_nil: true }
  validates :third_ball, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true , allow_nil: true }

  validate :less_than_or_equal_to_ten
  validate :third_ball_on_frame_ten
  validate :first_ball_before_second_ball
  validate :second_ball_before_third_ball

  private

  def less_than_or_equal_to_ten
    first_ball = self.first_ball || 0
    second_ball = self.second_ball || 0

    if number < 10 && first_ball + second_ball > 10
      errors.add(:base, "can't knock down more than 10 pins in one frame")
    end
  end

  def third_ball_on_frame_ten
    if !third_ball.nil?
      if number != 10
        errors.add(:third_ball, "cannot be bowled except in the 10th frame")
      else
        unless first_ball == 10 || first_ball + second_ball == 10
          errors.add(:third_ball, "cannot be bowled unless you have a 10th frame bonus roll")
        end
      end
    end
  end

  def first_ball_before_second_ball
    if first_ball.nil? && !second_ball.nil?
      errors.add(:second_ball, "cannot be rolled until the first ball is rolled")
    end
  end

  def second_ball_before_third_ball
    if second_ball.nil? && !third_ball.nil?
      errors.add(:third_ball, "cannot be rolled until the second ball is rolled")
    end
  end
end