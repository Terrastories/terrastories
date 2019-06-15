class MigratePlaceIdStoryIdtoJoinTablePlaceStory < ActiveRecord::Migration[5.2]
  def change
    points = Point.all.index_by(&:place_id)

    Place.find_each do |place|
    points = Point.where(place_id: place.id).map(&:id)
    related_stories = Story.where(point_id: points)
    place.stories << related_stories
    end
  end
end
