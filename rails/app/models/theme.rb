class Theme < ApplicationRecord
    
    has_many_attached :logos
    has_many_attached :community_logos
    validates :logos, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }
    validates :community_logos, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }
end
