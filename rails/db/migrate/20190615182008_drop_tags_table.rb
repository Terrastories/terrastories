class DropTagsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :tags
  end
end
