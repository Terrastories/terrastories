class Story < ApplicationRecord
  include Importable

  has_many :speaker_stories, inverse_of: :story
  has_many :speakers, through: :speaker_stories

  has_many :media, inverse_of: :story

  has_and_belongs_to_many :places, -> { with_valid_coordinates }
  belongs_to :community, touch: true
  belongs_to :interview_location, class_name: "Place", foreign_key: "interview_location_id", optional: true
  belongs_to :interviewer, class_name: "Speaker", foreign_key: "interviewer_id", optional: true
  has_many :media_links

  validates :title, presence: true
  validates :speaker_ids, presence: true
  validates :place_ids, presence: true

  accepts_nested_attributes_for :media

  def media_types
    media.flat_map do |m|
      registry, kind = m.content_type.split('/')

      registry == "application" ? kind : registry
    end.uniq
  end

  def media_preview_thumbnail
    previewable_media = media.find { |m| m.representable? }

    return unless previewable_media

    Rails.application.routes.url_helpers.rails_representation_url(
      previewable_media.media.representation(resize_to_limit: [200, 200]).processed
    )
  rescue ActiveStorage::Error
    nil
  end

  def self.export_sample_csv
    headers = %w{name description speakers places interview_location date_interviewed interviewer language media permission_level }

    CSV.generate(headers: true) do |csv|
      csv << headers
    end
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

  def public_points
    places.map(&:public_point_feature)
  end

  enum permission_level: [:anonymous, :user_only, :editor_only]

  EXCLUDE_ATTRIBUTES_FROM_IMPORT = %i[
    speaker_stories
    media_links
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
