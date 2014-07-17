class CreateClosedGames < ActiveRecord::Migration
  def change
    create_table :closed_games do |t|
      t.integer :game_id
      t.integer :left
      t.integer :right
      t.integer :judge
      t.integer :scoreright
      t.integer :scoreleft
      t.timestamps
    end
  end
end
