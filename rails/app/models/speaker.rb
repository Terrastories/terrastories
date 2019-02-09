# == Schema Information ==
#
# Table name: speakers
# 
# id          ... not null primary key
# speaker_name... string
# birth_year  ... datetime, nil if blank
# birthplace  ... string, classname: place
# photo       ... string, url to attached media
# region ------ removed
# community --- removed
# created_at  ... datetime, not null
# updated_at  ... datetime, not null

class Speaker < ApplicationRecord
  has_many :stories
  has_one :birthplace, class_name: Place
  has_one_attached :media

  # photo
  def picture_url
    if media.attached?
      Rails.application.routes.url_helpers.rails_blob_path(media, only_path: true)
    else
      ActionController::Base.helpers.image_path('speaker.png', only_path: true)
    end
  end

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      speaker = Speaker.where(
        name: row[0], 
        birth_year: row[1].nil? ? nil : Date.parse(row[1]), 
        birthplace: Place.find_by(name: row[2])).first_or_create

      if row[3] && File.exist?(Rails.root.join('media', row[3]))
        file = File.open(Rails.root.join('media',row[3]))
        speaker.media.attach(io: file, filename: row[3])
      
        speaker.save
    end
  end
end
