class AddCommunityIdToThemes < ActiveRecord::Migration[5.2]
  def change
    add_column :themes, :community_id, :integer, foreign_key: true
  end
end
