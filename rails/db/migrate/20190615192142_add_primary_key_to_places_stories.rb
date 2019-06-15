class AddPrimaryKeyToPlacesStories < ActiveRecord::Migration[5.2]
  def change
    add_column :places_stories, :id, :primary_key
  end
end
