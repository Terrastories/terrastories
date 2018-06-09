class AddPointIdToStory < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :point_id, :string
  end
end
