class AddCommunityIdToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :community_id, :integer, foreign_key: true
  end
end
