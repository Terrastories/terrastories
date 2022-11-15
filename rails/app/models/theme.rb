class Theme < ApplicationRecord
  include MapConfigurable

  belongs_to :community, touch: true

  has_one_attached :background_img
  has_many_attached :sponsor_logos
  after_initialize :set_map_defaults

  validates :background_img, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }
  validates :sponsor_logos, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }

  validates :mapbox_access_token, presence: true, unless: -> { mapbox_style_url.blank? }
  validates :mapbox_style_url, presence: true, unless: -> { mapbox_access_token.blank? }

  validate :map_bounds
  validates :center_lat,
    numericality: true, allow_nil: true, inclusion: {in: -90..90, message: :invalid_latitude}
  validates :center_long,
    numericality: true, allow_nil: true, inclusion: {in: -180..180, message: :invalid_longitude}
  validates :bearing,
    numericality: true, allow_nil: true, inclusion: {in: -180..180, message: :invalid_bearing}
  validates :zoom,
    numericality: true, allow_nil: true, inclusion: {in: 0..22, message: :invalid_zoom_level}
  validates :pitch,
    numericality: true, allow_nil: true, inclusion: {in: 0..85, message: :invalid_pitch}

  def static_map_pitch
    pitch.to_i > 60 ? 60 : pitch.to_i
  end

  def mapbox_token
    if mapbox_access_token.present? && !offline_mode?
      mapbox_access_token
    else
      Rails.application.config.default_mapbox_token
    end
  end

  def mapbox_style
    if mapbox_style_url.present? && !offline_mode?
      mapbox_style_url
    else
      Rails.application.config.default_map_style
    end
  end

  def offline_mode?
    Rails.application.config.offline_mode
  end

  def all_boundaries_nil?
    sw_boundary_long.nil? && sw_boundary_lat.nil? && ne_boundary_long.nil? && ne_boundary_lat.nil?
  end

  private

  # validate bounding box if all four values are nil OR if all four values are numeric & in the proper range
  def map_bounds
    return if all_boundaries_nil?

    if sw_boundary_long.nil? || sw_boundary_lat.nil? || ne_boundary_long.nil? || ne_boundary_lat.nil?
      errors.add(:base, :map_bounds) # at least one nil and at least one numeric
    end
    errors.add(:sw_boundary_lat, :invalid_latitude) unless (-90..90).include?(sw_boundary_lat)
    errors.add(:ne_boundary_lat, :invalid_latitude) unless (-90..90).include?(ne_boundary_lat)
    errors.add(:sw_boundary_long, :invalid_longitude) unless (-180..180).include?(sw_boundary_long)
    errors.add(:ne_boundary_long, :invalid_longitude) unless (-180..180).include?(ne_boundary_long)
  end

  enum map_projection: [:mercator, :albers, :equalEarth, :equirectangular, :lambertConformalConic, :naturalEarth, :winkelTripel, :globe]
end

# == Schema Information
#
# Table name: themes
#
#  id                  :bigint           not null, primary key
#  active              :boolean          default(FALSE), not null
#  bearing             :decimal(10, 6)
#  center_lat          :decimal(10, 6)
#  center_long         :decimal(10, 6)
#  map_projection      :integer          default("mercator")
#  mapbox_3d           :boolean          default(FALSE)
#  mapbox_access_token :string
#  mapbox_style_url    :string
#  ne_boundary_lat     :decimal(10, 6)
#  ne_boundary_long    :decimal(10, 6)
#  pitch               :decimal(10, 6)
#  sw_boundary_lat     :decimal(10, 6)
#  sw_boundary_long    :decimal(10, 6)
#  zoom                :decimal(10, 6)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  community_id        :bigint           not null
#
# Foreign Keys
#
#  fk_rails_...  (community_id => communities.id)
#
