class DropTablePlacesStories < ActiveRecord::Migration[5.2]
  def change
    drop_table :places_stories
  end
end
