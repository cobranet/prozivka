class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :left
      t.integer :right
      t.integer :judge 
      t.timestamps
    end
  end
end
