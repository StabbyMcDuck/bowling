class Player < ApplicationRecord
  belongs_to :game
  has_many :frames

  # validations
  validates :game, presence: true
  validates :name, presence: true
end
