class AddRegionToPlace < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :region, :string
  end
end
