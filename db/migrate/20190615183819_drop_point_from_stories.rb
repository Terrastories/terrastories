class DropPointFromStories < ActiveRecord::Migration[5.2]
  def change
    remove_column :stories, :point_id, :bigint
  end
end
