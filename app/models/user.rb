class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :answer_games, through: :games
  has_many :games
  has_many :decks, through: :games
end
