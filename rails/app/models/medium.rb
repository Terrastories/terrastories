class Medium < ApplicationRecord
  self.table_name = "media"

  belongs_to :story

  has_one_attached :media

  validates :media,
    attached: true,
    # Symbol Content Types must map in Marcel::EXTENSIONS
    # otherwise, use string for full mime type.
    content_type: [
      # image types
      :png, :jpeg, :svg, 'image/jpg',
      # video types
      :mpeg, :mp4, :mov, :webm,
      # audio types
      :mp3, :aac, :flac, :mp4a, :wav,
      'audio/wav', 'audio/m4a', 'audio/x-m4a', 'audio/x-aac', 'audio/x-flac',
    ]
end

# == Schema Information
#
# Table name: media
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  story_id   :bigint
#
# Indexes
#
#  index_media_on_story_id  (story_id)
#
