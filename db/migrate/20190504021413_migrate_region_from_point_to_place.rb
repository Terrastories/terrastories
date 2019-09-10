class MigrateRegionFromPointToPlace < ActiveRecord::Migration[5.2]
  def change
    points = Point.all.index_by(&:place_id)

     Place.find_each do |place|
      point = points[place.id]
      place.update!(
        region: point.region
      )
    end
  end
end
