class AddPointsToStory < ActiveRecord::Migration[5.2]
  def change
    add_reference :stories, :point, foreign_key: true
  end
end
