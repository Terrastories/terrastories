class AddLanguageAndInterviewerIdToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :interviewer_id, :integer
  end
end
