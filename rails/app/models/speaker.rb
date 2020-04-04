# == Schema Information ==
#
# Table name: speakers
# 
# id          ... not null primary key
# speaker_name... string
# birth_year  ... datetime, nil if blank
# birthplace_id  ... integer, classname: place
# photo       ... string, url to attached media
# region ------ removed
# community ... string
# created_at  ... datetime, not null
# updated_at  ... datetime, not null

class Speaker < ApplicationRecord
  has_many :speaker_stories
  has_many :stories, through: :speaker_stories
  belongs_to :birthplace, class_name: "Place",  optional: true
  has_one_attached :photo

  # photo
  def picture_url
    if photo.attached?
      Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)
    else
      ActionController::Base.helpers.image_path('speaker.png', only_path: true)
    end
  end

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      speaker = Speaker.find_or_create_by(name: row[0])
      speaker.birthplace = get_birthplace(row[2])
      # Assumes birth date field is always just a year
      speaker.birthdate = row[1].nil? || row[1].downcase == 'unknown' ? nil : Date.strptime(row[1], "%Y")
      if row[3] && File.exist?(Rails.root.join('media', row[3]))
        file = File.open(Rails.root.join('media',row[3]))
        speaker.photo.attach(io: file, filename: row[3])
      end
      speaker.save
    end
  end

  def self.get_birthplace(name)
    if name.nil? || name.downcase == 'unknown'
      return nil
    end
    Place.find_or_create_by(name: name)
  end
end
