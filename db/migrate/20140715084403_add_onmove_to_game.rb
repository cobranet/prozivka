class AddOnmoveToGame < ActiveRecord::Migration
  def change
    add_column :games, :onmove, :integer
  end
end
