class ChangeDescTypeStories < ActiveRecord::Migration[5.2]
  def change
    change_column :stories, :desc, :text
  end
end
