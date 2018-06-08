class PointsController < ApplicationController
  def index
    @points = Point.all
		collection = RGeo::GeoJSON::FeatureCollection.new(
			@points.map do |point|
				RGeo::GeoJSON::Feature.new(
					RGeo::Cartesian.factory.point(point.long, point.lat), point.id, name: point.name
				)
			end
    )

    render json: RGeo::GeoJSON.encode(collection)
  end
end
