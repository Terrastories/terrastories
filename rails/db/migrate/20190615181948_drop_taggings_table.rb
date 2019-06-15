class DropTaggingsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :taggings
  end
end
