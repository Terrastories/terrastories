class CreateJoinTablePlaceStory < ActiveRecord::Migration[5.2]
  def change
    create_join_table :places, :stories do |t|
      t.index [:place_id, :story_id]
    end
  end
end
