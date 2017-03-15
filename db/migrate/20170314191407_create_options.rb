class CreateOptions < ActiveRecord::Migration
  def change
      create_table :options do |t|
      t.belongs_to :question, index: true
      t.string :option
      t.string :answer, default: false 
      t.timestamps
    end
  end
end
