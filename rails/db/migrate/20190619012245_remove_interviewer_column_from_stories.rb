class RemoveInterviewerColumnFromStories < ActiveRecord::Migration[5.2]
  def change
    remove_column :stories, :interviewer, :string
  end
end
