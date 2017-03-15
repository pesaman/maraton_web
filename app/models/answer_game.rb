class AnswerGame < ActiveRecord::Base
  # Remember to create a migration!
   belongs_to :game
   belongs_to :question
end
