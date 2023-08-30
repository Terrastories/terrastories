class Place < ApplicationRecord
  include Importable

  belongs_to :community, touch: true
  has_and_belongs_to_many :stories
  has_one_attached :photo
  has_one_attached :name_audio
  validates :name, presence: true
  validates :photo, content_type: [:png, 'image/jpg', :jpeg], size: { less_than_or_equal_to: 5.megabytes }
  validates :name_audio,
    content_type: [
      :mp3, :aac, :flac, :mp4a, :wav,
      'audio/wav', 'audio/m4a', 'audio/x-m4a', 'audio/x-aac', 'audio/x-flac',
    ],
    size: { less_than_or_equal_to: 10.megabytes }
  validates :lat, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90, message: :invalid_latitude }, allow_blank: true
  validates :long, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, message: :invalid_longitude}, allow_blank: true
  has_many :interview_stories, class_name: "Story", foreign_key: "interview_location_id"

  attr_reader :point_geojson

  def photo_url(full_url: false, thumbnail: false)
    if photo.attached?
      if full_url
        resize_limit = thumbnail ? [300, 300] : [800, 800]
        Rails.application.routes.url_helpers.rails_representation_url(photo.variant(resize_to_limit: resize_limit))
      else
        Rails.application.routes.url_helpers.rails_blob_path(photo)
      end
    end
  end

  def name_audio_url(full_url: false)
    if name_audio.attached?
      if full_url
        Rails.application.routes.url_helpers.rails_blob_url(name_audio)
      else
        Rails.application.routes.url_helpers.rails_blob_path(name_audio)
      end
    end
  end

  def point_geojson
    RGeo::GeoJSON.encode geojson
  end

  def self.export_sample_csv
    headers = %w{ name type_of_place description region long lat media }

    CSV.generate(headers: true) do |csv|
      csv << headers
    end
  end

  def static_map_markers
    geo = RGeo::GeoJSON.encode(
      RGeo::GeoJSON::Feature.new(
        RGeo::Cartesian.factory.point(long, lat),
        id,
        "marker-symbol": name[0]&.downcase || "P"
      )
    ).to_json
  end

  # keys are camelCased for Public Communities React FrontEnd
  def public_point_feature
    RGeo::GeoJSON.encode(
      RGeo::GeoJSON::Feature.new(
        RGeo::Cartesian.factory.point(long, lat),
        id,
        name: name,
        description: description,
        placenameAudio: name_audio_url(full_url: true),
        photo: photo_url(full_url: true),
        thumbnail: photo_url(full_url: true, thumbnail: true),
        region: region,
        typeOfPlace: type_of_place,
      )
    )
  end

  EXCLUDE_ATTRIBUTES_FROM_IMPORT = %i[
    stories
    interview_stories
  ]

  private

  def geojson
    # todo: add extra data here to pass to map about points
    RGeo::GeoJSON::Feature.new(
      RGeo::Cartesian.factory.point(long, lat),
      id,
      name: name,
      description: description,
      region: region,
      type_of_place: type_of_place,
      photo_url: photo_url,
      name_audio_url: name_audio_url,
      stories: stories
    )
  end

end

# == Schema Information
#
# Table name: places
#
#  id            :bigint           not null, primary key
#  description   :string
#  lat           :decimal(10, 6)
#  long          :decimal(10, 6)
#  name          :string
#  region        :string
#  type_of_place :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  community_id  :integer
#
