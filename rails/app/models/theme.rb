class Theme < ApplicationRecord
    
    has_many_attached :logos
    validates :logos, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }

end
