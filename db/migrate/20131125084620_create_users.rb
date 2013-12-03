class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :password_question
      t.string :password_question_answer

      t.timestamps
    end
  end
end
