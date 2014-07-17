class CreateUserStats < ActiveRecord::Migration
  def change
    create_table :user_stats do |t|
      t.integer :user_id
      t.integer :games_won
      t.integer :games_played
      t.integer :games_judged
      t.timestamps
    end
  end
end
