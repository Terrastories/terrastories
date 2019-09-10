class RemoveStoryAndLocationTypeFromPoint < ActiveRecord::Migration[5.2]
  def change
    remove_column :points, :story, :string
    remove_column :points, :location_type, :string
  end
end
