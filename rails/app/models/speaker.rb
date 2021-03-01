class Speaker < ApplicationRecord
  require 'csv'

  has_many :speaker_stories
  has_many :stories, through: :speaker_stories
  belongs_to :community
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

  def self.import_csv(filename, community)
    ApplicationController.helpers.csv_importer(filename, self, community)
  end

  def self.get_birthplace(name, community)
    if name.nil? || name.downcase == 'unknown'
      return nil
    end
    Place.find_or_create_by(name: name, community: community)
  end

  def self.export_sample_csv
    headers = %w{ name birthdate birthplace media }

    CSV.generate(headers: true) do |csv|
      csv << headers
    end
  end
end

# == Schema Information
#
# Table name: speakers
#
#  id                :bigint           not null, primary key
#  birthdate         :datetime
#  name              :string
#  photo             :string
#  speaker_community :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  birthplace_id     :integer
#  community_id      :integer
#
# Indexes
#
#  index_speakers_on_birthplace_id  (birthplace_id)
#
