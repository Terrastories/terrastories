class Place < ApplicationRecord
  require 'csv'
  has_and_belongs_to_many :stories
  has_one_attached :photo
  validate :photo_format
  has_many :interview_stories, class_name: "Story", foreign_key: "interview_location_id"

  attr_reader :point_geojson

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      place = Place.find_or_create_by(name: row[0])
      place.lat = row[5].to_f
      place.long = row[4].to_f
      place.type_of_place = row[1]
      place.description = row[2]
      place.region = row[3]
      if row[6] && File.exist?(Rails.root.join('media', row[6]))
        file = File.open(Rails.root.join('media',row[6]))
        place.photo.attach(io: file, filename: row[6])
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

  def photo_url
    if photo.attached?
      Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)
    end
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
      type_of_place: type_of_place,
      photo_url: photo_url,
      stories: stories
    )
  end

end
