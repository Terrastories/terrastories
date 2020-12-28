class AddCommunityIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :community_id, :integer, foreign_key: true
  end
end
