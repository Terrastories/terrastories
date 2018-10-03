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

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      Speaker.where(name: row[0], community: row[2]).first_or_create
    end
  end

end
