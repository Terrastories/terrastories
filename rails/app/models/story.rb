class Story < ApplicationRecord
  include Importable
  MEDIA_PATH = Rails.env.test? ? 'spec/fixtures/media' : 'import/media'

  has_many :speaker_stories, inverse_of: :story
  has_many :speakers, through: :speaker_stories
  has_many_attached :media
  has_and_belongs_to_many :places
  belongs_to :community
  belongs_to :interview_location, class_name: "Place", foreign_key: "interview_location_id", optional: true
  belongs_to :interviewer, class_name: "Speaker", foreign_key: "interviewer_id", optional: true
  has_many :media_links

  validates :title, presence: true
  validates :speaker_ids, presence: true
  validates :place_ids, presence: true
  validates :media, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'video/mpeg', 'video/mp4', 'video/quicktime', 'video/webm', 'audio/mpeg', 'audio/wav', 'audio/m4a'] }

  def self.import_csv(file_contents, community)
    ApplicationController.helpers.csv_importer(file_contents, self, community)
  end

  def self.export_sample_csv
    headers = %w{name description speakers places interview_location date_interviewed interviewer language media permission_level }

    CSV.generate(headers: true) do |csv|
      csv << headers
    end
  end

  def geo_center
    Geocoder::Calculations.geographic_center(places.map { |p| [p.lat, p.long] }).reverse
  end

  def static_map_markers
    RGeo::GeoJSON.encode(
      RGeo::GeoJSON::FeatureCollection.new(
        places.map { |p|
          RGeo::GeoJSON::Feature.new(
            RGeo::Cartesian.factory.point(p.long, p.lat),
            p.id,
            "marker-symbol": p.name[0]
          )
        }
      )
    ).to_json
  end

  enum permission_level: [:anonymous, :user_only, :editor_only]

  EXCLUDE_ATTRIBUTES_FROM_IMPORT = [
    "speaker_stories",
    "media_attachments",
    "media_links",
    "media_blobs"
  ]
end

# == Schema Information
#
# Table name: stories
#
#  id                    :bigint           not null, primary key
#  date_interviewed      :datetime
#  desc                  :text
#  language              :string
#  permission_level      :integer
#  title                 :string
#  topic                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  community_id          :integer
#  interview_location_id :integer
#  interviewer_id        :integer
#
