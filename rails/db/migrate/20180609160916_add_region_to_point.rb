class AddRegionToPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :points, :region, :string
  end
end
