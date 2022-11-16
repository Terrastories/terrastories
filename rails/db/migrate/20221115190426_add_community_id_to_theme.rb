class AddCommunityIdToTheme < ActiveRecord::Migration[6.1]
  def up
    add_column :themes, :community_id, :bigint, foreign_key: true

    Community.where.not(theme_id: nil).find_each do |community|
      Theme.find_by(id: community.theme_id)&.update(
        community_id: community.id
      )
    end

    # This is so we can add NOT NULL constraint for data integrity
    Theme.where(community_id: nil).update_all(community_id: 0)

    change_column_null :themes, :community_id, false
  end

  def down
    Theme.where.not(community_id: nil).find_each do |theme|
      Community.find_by(id: theme.community_id)&.update(theme_id: theme.id)
    end

    remove_column :themes, :community_id
  end
end
