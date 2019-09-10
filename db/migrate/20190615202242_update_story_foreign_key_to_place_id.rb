class UpdateStoryForeignKeyToPlaceId < ActiveRecord::Migration[5.2]
  def change
    rename_column :stories, :interview_location_id, :place_id
  end
end
