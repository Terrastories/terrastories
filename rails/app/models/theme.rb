class Theme < ApplicationRecord
  has_one_attached :background_img
  has_many_attached :sponsor_logos

  validates :background_img, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }
  validates :sponsor_logos, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }
end

# == Schema Information
#
# Table name: themes
#
#  id                  :bigint           not null, primary key
#  active              :boolean          default(FALSE), not null
#  mapbox_access_token :string
#  mapbox_style_url    :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
