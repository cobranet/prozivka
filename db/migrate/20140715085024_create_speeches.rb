class CreateSpeeches < ActiveRecord::Migration
  def change
    create_table :speeches do |t|
      t.integer :game_id
      t.integer :rb
      t.integer :user_id
      t.integer :score
      t.string :speech
      t.timestamps
    end
  end
end
