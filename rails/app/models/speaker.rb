class Speaker < ApplicationRecord
  include Importable

  has_many :speaker_stories
  has_many :stories, through: :speaker_stories
  belongs_to :community, touch: true
  belongs_to :birthplace, class_name: "Place",  optional: true
  has_one_attached :photo

  validates :name, presence: true

  validates :photo, content_type: [:png, :jpeg], size: { less_than_or_equal_to: 5.megabytes }

  # photo
  def picture_url
    if photo.attached?
      Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)
    else
      ActionController::Base.helpers.image_path('speaker.png', only_path: true)
    end
  end

  def self.export_sample_csv
    headers = %w{ name birthdate birthplace media }

    CSV.generate(headers: true) do |csv|
      csv << headers
    end
  end

  EXCLUDE_ATTRIBUTES_FROM_IMPORT = %i[
    stories
    speaker_stories
  ]
end

# == Schema Information
#
# Table name: speakers
#
#  id                :bigint           not null, primary key
#  birthdate         :datetime
#  name              :string
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
