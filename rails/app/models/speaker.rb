class Speaker < ApplicationRecord
  has_many :stories
  has_one_attached :media

  def picture_url
    if media.attached?
      Rails.application.routes.url_helpers.rails_blob_path(media, only_path: true)
    else
      ActionController::Base.helpers.image_path('speaker.png', only_path: true)
    end
  end
end
