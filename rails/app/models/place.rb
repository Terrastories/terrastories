class Place < ApplicationRecord
  require 'csv'
  has_and_belongs_to_many :stories
  has_one_attached :photo
  validate :photo_format

  attr_reader :point_geojson

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      place = Place.create(name: row[0], type_of_place: row[1], region: row[3], lat: row[5].to_f, long: row[4].to_f)
      if row[6] && File.exist?(Rails.root.join('media', row[6]))
        file = File.open(Rails.root.join('media',row[6]))
        place.photo.attach(io: file, filename: row[6])
        place.save
      end
      place.save
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
    # todo: add extra data here to pass to map about points
    RGeo::GeoJSON::Feature.new(
      RGeo::Cartesian.factory.point(long, lat),
      id,
      name: name,
      region: region,
      stories: stories
    )
  end

end
