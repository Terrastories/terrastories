class CombinePointsAndPlaces < ActiveRecord::Migration[5.2]
  def up
    add_column :places, :lat, :float
    add_column :places, :long, :float
  end
  def down
    remove_column :places, :lat
    remove_column :places, :long
  end
end