class AddStoryPinnedToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :story_pinned, :boolean, default: false
  end
end
