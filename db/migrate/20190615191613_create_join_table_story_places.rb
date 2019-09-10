class CreateJoinTableStoryPlaces < ActiveRecord::Migration[5.2]
  def change
    create_join_table :stories, :places do |t|
      t.index [:story_id, :place_id]
    end
  end
end
