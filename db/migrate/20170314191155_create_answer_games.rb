class CreateAnswerGames < ActiveRecord::Migration
  def change
      create_table :answer_games do |t|
      t.belongs_to :game, index: true
      t.belongs_to :question, index: true
      t.integer :user_answer
      t.integer :score
      t.timestamps
    end
  end
end
