class AddCommunityIdToPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :community_id, :integer, foreign_key: true
  end
end
