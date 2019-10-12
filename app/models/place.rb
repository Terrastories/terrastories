require 'csv'

class Place < ApplicationRecord
  has_many :interview_stories, class_name: 'Story', foreign_key: 'interview_location_id'
  has_and_belongs_to_many :stories

  has_one_attached :photo

  validate :photo, attached_file: { is: :image, allow_nil: true }

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

  def photo_url
    Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true) if photo.attached?
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
