class Place < ApplicationRecord
  require 'csv'
  has_many :points
  has_many :places_stories
  has_many :stories, through: :places_stories
  has_one_attached :photo
  validate :photo_format

  attr_reader :point_geojson

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      place = Place.create(name: row[0], type_of_place: row[1], region: row[3], lat: row[5].to_f, long: row[4].to_f)
      # keep existing points creation in case of a rollback
      loc = Place.find_by(name: row[0], type_of_place: row[1])
      loc.points.create(title:row[0], lat: row[5].to_f, lng: row[4].to_f, region: row[3])
    end
  end

  def photo_format
    return unless photo.attached?
    return if photo.blob.content_type.start_with? 'image/'
    photo.purge_later
    errors.add(:photo, 'needs to be an image')
  end

  def point_geojson
    RGeo::GeoJSON.encode geojson
  end

  private

  def geojson
    RGeo::GeoJSON::Feature.new(
      RGeo::Cartesian.factory.point(long, lat),
      id,
      name: name,
      region: region,
      stories: stories
    )
  end

end
