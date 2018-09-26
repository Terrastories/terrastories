class AddAccessToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :permission_level, :integer
  end
end
