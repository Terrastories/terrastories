class AddPointIdToStory < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :point_id, :integer
  end
end
