class Theme < ApplicationRecord
  include MapConfigurable
  has_one_attached :background_img
  has_many_attached :sponsor_logos
  after_initialize :set_map_defaults

  validates :background_img, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }
  validates :sponsor_logos, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }
  validates :mapbox_access_token, :presence => {:message => 'You need a Mapbox access token to go along with your Mapbox style URL'}, unless: -> { mapbox_style_url.blank? }
  validates :mapbox_style_url, :presence => {:message => 'You need a Mapbox style URL to go along with your access token'}, unless: -> { mapbox_access_token.blank? }
  validates :center_lat, :sw_boundary_lat, :ne_boundary_lat,
    :numericality=> true, allow_nil: true, :inclusion => {:in => -90..90, :message => "value should be between -90 and 90"}
  validates :bearing, :center_long, :sw_boundary_long, :ne_boundary_long,
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
#  ne_boundary_lat     :decimal(10, 6)
#  ne_boundary_long    :decimal(10, 6)
#  pitch               :decimal(10, 6)
#  sw_boundary_lat     :decimal(10, 6)
#  sw_boundary_long    :decimal(10, 6)
#  zoom                :decimal(10, 6)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
