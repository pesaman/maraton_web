class Question < ActiveRecord::Base
  # Remember to create a migration!
  has_many :options
  belongs_to :deck
  has_many :answer_games
  has_many :games, through: :answer_games
end
