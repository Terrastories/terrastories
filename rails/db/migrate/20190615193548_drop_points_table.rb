class DropPointsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :points
  end
end
