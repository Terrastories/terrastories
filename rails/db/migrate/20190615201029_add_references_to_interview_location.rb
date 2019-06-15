class AddReferencesToInterviewLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :interview_location_id, :integer
  end
end
