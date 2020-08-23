class Place < ApplicationRecord
  MEDIA_PATH = Rails.env.test? ? 'spec/fixtures/media' : 'media'

  require 'csv'
  has_and_belongs_to_many :stories
  has_one_attached :photo
  validate :photo_format
  validates :lat, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }, allow_blank: true
  validates :long, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_blank: true
  has_many :interview_stories, class_name: "Story", foreign_key: "interview_location_id"

  attr_reader :point_geojson

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      decorator = FileImport::PlaceRowDecorator.new(row)
      place = Place.find_or_create_by(decorator.to_h)
      place.photo.attach(decorator.media.blob_data) if decorator.media.attachable?

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
