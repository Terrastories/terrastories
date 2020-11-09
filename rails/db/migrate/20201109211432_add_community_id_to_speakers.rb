class AddCommunityIdToSpeakers < ActiveRecord::Migration[5.2]
  def change
    add_column :speakers, :community_id, :integer, foreign_key: true
  end
end
