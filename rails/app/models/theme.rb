class Theme < ApplicationRecord
  include MapConfigurable
  has_one_attached :background_img
  has_many_attached :sponsor_logos
  has_one :community
  after_initialize :set_map_defaults

  validates :background_img, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }
  validates :sponsor_logos, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }
  validates :mapbox_access_token, :presence =>  {:message => 'is required when the Mapbox style URL is set.'}, unless: -> { mapbox_style_url.blank? }
  validates :mapbox_style_url, :presence => {:message => 'is required when the Mapbox access token is set.'}, unless: -> { mapbox_access_token.blank? }
  validate :map_bounds
   # validate bounding box if all four values are nil OR if all four values are numeric & in the proper range
   def map_bounds
     return if sw_boundary_long.nil? && sw_boundary_lat.nil? && ne_boundary_long.nil? && ne_boundary_lat.nil?

     if sw_boundary_long.nil? || sw_boundary_lat.nil? || ne_boundary_long.nil? || ne_boundary_lat.nil?
       errors.add(:base, "All four bounding box values must be set, or left blank") # at least one nil and at least one numeric
     end
     errors.add(:sw_boundary_lat, "value should be between -90 and 90") unless (-90..90).include?(sw_boundary_lat)
     errors.add(:ne_boundary_lat, "value should be between -90 and 90") unless (-90..90).include?(ne_boundary_lat)
     errors.add(:sw_boundary_long, "value should be between -180 and 180") unless (-180..180).include?(sw_boundary_long)
     errors.add(:ne_boundary_long, "value should be between -180 and 180") unless (-180..180).include?(ne_boundary_long)
   end
  validates :center_lat,
    :numericality=> true, allow_nil: true, :inclusion => {:in => -90..90, :message => "value should be between -90 and 90"}
  validates :bearing, :center_long,
    :numericality=> true, allow_nil: true, :inclusion => {:in => -180..180, :message => "value should be between -180 and 180"}
  validates :zoom,
    :numericality=> true, allow_nil: true, :inclusion => {:in => 0..22, :message => "value should be between 0 and 22"}
  validates :pitch,
    :numericality=> true, allow_nil: true, :inclusion => {:in => 0..85, :message => "value should be between 0 and 85"}
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
#  mapbox_access_token :string
#  mapbox_style_url    :string
#  mapbox_3d           :boolean          default(FALSE), not null
#  ne_boundary_lat     :decimal(10, 6)
#  ne_boundary_long    :decimal(10, 6)
#  pitch               :decimal(10, 6)
#  sw_boundary_lat     :decimal(10, 6)
#  sw_boundary_long    :decimal(10, 6)
#  zoom                :decimal(10, 6)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
