class ChangeStoryPermissionLevelToBoolean < ActiveRecord::Migration[5.2]
  def up
    add_column :stories, :is_public, :boolean
    Story.reset_column_information
    Story.where(permission_level: 0).update_all(is_public: true)
    Story.where(permission_level: 1).update_all(is_public: false)
    remove_column :stories, :permission_level, :integer
  end

  def down
    add_column :stories, :permission_level, :integer
    Story.reset_column_information
    Story.where(is_public: true).update_all(permission_level: 0)
    Story.where(is_public: false).update_all(permission_level: 1)
    remove_column :stories, :is_public, :boolean
  end
end
