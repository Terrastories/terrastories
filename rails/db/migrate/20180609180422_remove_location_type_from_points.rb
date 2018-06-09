class RemoveLocationTypeFromPoints < ActiveRecord::Migration[5.2]
  def change
    remove_column :points, :location_type
  end
end
