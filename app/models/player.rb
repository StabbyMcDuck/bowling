class Player < ApplicationRecord
  belongs_to :game

  # validations
  validates :game, presence: true
  validates :name, presence: true
end
