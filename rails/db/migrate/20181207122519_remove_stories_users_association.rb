class RemoveStoriesUsersAssociation < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :stories, :users
  end
end
