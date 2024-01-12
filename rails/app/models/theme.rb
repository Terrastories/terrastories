class Theme < ApplicationRecord
  include MapConfigurable

  has_one_attached :static_map

  belongs_to :community, touch: true

  # TODO: Once Feature: split_settings is enabled for everyoen
  # we can remove nested attributes.
  accepts_nested_attributes_for :community

  after_initialize :set_map_defaults

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

  def mapbox_token
    if mapbox_access_token.present? && !Map.offline?
      mapbox_access_token
    else
      Map.mapbox_access_token
    end
  end

  def basemap_style
    return "default" if Map.offline? || !use_maplibre?

    if protomaps_basemap_style.present?
      protomaps_basemap_style
    else
      "contrast"
    end
  end

  def map_style_url
    return Map.default_style if Map.offline?

    if protomaps_api_key.present?
      "https://api.protomaps.com/tiles/v3.json?key=#{protomaps_api_key}"
    else
      mapbox_style
    end
  end

  def mapbox_style
    if mapbox_style_url.present? && !Map.offline?
      mapbox_style_url
    else
      Map.default_style
    end
  end

  def use_maplibre?
    Map.offline? || protomaps_api_key.present? || !(Map.use_mapbox? || mapbox_access_token.present?)
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
#  id                      :bigint           not null, primary key
#  active                  :boolean          default(FALSE), not null
#  bearing                 :decimal(10, 6)
#  center_lat              :decimal(10, 6)
#  center_long             :decimal(10, 6)
#  map_projection          :integer          default("mercator")
#  mapbox_3d               :boolean          default(FALSE)
#  mapbox_access_token     :string
#  mapbox_style_url        :string
#  ne_boundary_lat         :decimal(10, 6)
#  ne_boundary_long        :decimal(10, 6)
#  pitch                   :decimal(10, 6)
#  protomaps_api_key       :text
#  protomaps_basemap_style :text
#  sw_boundary_lat         :decimal(10, 6)
#  sw_boundary_long        :decimal(10, 6)
#  zoom                    :decimal(10, 6)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  community_id            :bigint           not null
#
