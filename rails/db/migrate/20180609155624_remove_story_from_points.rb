class RemoveStoryFromPoints < ActiveRecord::Migration[5.2]
  def change
    remove_column :points, :story
  end
end
