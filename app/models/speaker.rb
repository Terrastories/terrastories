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
  include Importable

  importer Importing::SpeakersImporter

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
end
