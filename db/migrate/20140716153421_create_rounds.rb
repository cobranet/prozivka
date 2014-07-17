class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.column :game_id, :integer
      t.column :round_num, :integer
      t.column :task, :string
      t.timestamps
    end
  end
end
