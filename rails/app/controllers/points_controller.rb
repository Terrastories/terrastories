class PointsController < ApplicationController
  def index
    @points = Point.all
		collection = RGeo::GeoJSON::FeatureCollection.new(
			@points.map do |point|
				RGeo::GeoJSON::Feature.new(
          RGeo::Cartesian.factory.point(point.lng, point.lat),
            point.id,
            title: point.title,
            story: point.story,
            location_type: point.location_type,
				)
			end
    )

    render json: RGeo::GeoJSON.encode(collection)
  end
end
