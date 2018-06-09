class AddPointReferenceToStory < ActiveRecord::Migration[5.2]
  def change
    remove_column :stories, :point_id
    add_reference :stories, :point, foreign_key: true
  end
end
