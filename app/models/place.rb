class Place < ApplicationRecord
  include Importable

  importer Importing::PlacesImporter

  has_and_belongs_to_many :stories
  has_one_attached :photo
  has_many :interview_stories, class_name: "Story", foreign_key: "interview_location_id"
  validate :photo_format

  attr_reader :point_geojson

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
