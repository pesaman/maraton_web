class Game < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :user
  belongs_to :deck
  has_many :answer_games 
  has_many :questions, through: :answer_games
end
