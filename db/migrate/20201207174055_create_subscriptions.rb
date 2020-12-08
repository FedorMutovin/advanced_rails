class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.belongs_to :question, foreign_key: true
      t.index [:question_id, :user_id], unique: true
      t.timestamps
    end
  end
end
