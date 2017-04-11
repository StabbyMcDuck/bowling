class Frame < ApplicationRecord
  belongs_to :player

  #validations
  validates :player, presence: true
  validates :number, numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates :first_ball, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :second_ball, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }

  validate :less_than_or_equal_to_ten

  private

  def less_than_or_equal_to_ten
    first_ball = self.first_ball || 0
    second_ball = self.second_ball || 0

    if first_ball + second_ball > 10
      errors.add(:base, "can't knock down more than 10 pins in one frame")
    end
  end

end