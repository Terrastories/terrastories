class ConvertPointToPlaceId < ActiveRecord::Migration[5.2]
  def change
    points = Point.all.index_by(&:place_id)

    Place.find_each do |place|
      point = points[place.id]
      place.update!(
        lat: point.lat,
        long: point.lng
      )
    end
  end
end
