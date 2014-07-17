class AddScoreToGame < ActiveRecord::Migration
  def change
    add_column :games, :scoreleft,  :integer
    add_column :games, :scoreright, :integer
  end
end
