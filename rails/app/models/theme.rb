class Theme < ApplicationRecord
  has_many_attached :sponsor_logos

  validates :sponsor_logos, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }
end
