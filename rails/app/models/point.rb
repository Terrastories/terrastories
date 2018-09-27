class Point < ApplicationRecord
  has_many :stories
  belongs_to :place
  acts_as_taggable
  attr_reader :point_geojson

  def point_geojson
    RGeo::GeoJSON.encode geojson
  end

  private

  def geojson
    RGeo::GeoJSON::Feature.new(
      RGeo::Cartesian.factory.point(lng, lat),
      id,
      title: title,
      region: region,
      stories: stories
    )
  end
end
