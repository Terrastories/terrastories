class AddCommunityIdToTheme < ActiveRecord::Migration[6.1]
  def up
    add_column :themes, :community_id, :bigint, foreign_key: true

    Theme.find_each do |theme|
      theme.community_id = theme.community.id
      theme.save
    end

    add_foreign_key :themes, :communities
    change_column_null :themes, :community_id, false
  end

  def down
    remove_column :themes, :community_id
  end
end
