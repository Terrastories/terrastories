class ChangeColumnToInterviewLocationId < ActiveRecord::Migration[5.2]
  def change
    rename_column :stories, :place_id, :interview_location_id
  end
end
