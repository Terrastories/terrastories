class AddDemographicAssociations < ActiveRecord::Migration[5.2]
  def change
    create_join_table :demographics, :stories
    create_join_table :demographics, :users
    create_join_table :stories, :users
  end
end
