class AddPlaceIdToPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :points, :place_id, :integer
    add_index  :points, :place_id
  end
end
