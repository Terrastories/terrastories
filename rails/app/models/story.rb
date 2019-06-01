class Story < ApplicationRecord
  belongs_to :point
  has_many :speaker_stories
  has_many :speakers, through: :speaker_stories
  has_many_attached :media
  has_many :interview_locations, through: :places

  acts_as_taggable

  def self.import_csv(filename)
    arr_rows = CSV.parse(filename)

    arr_rows.each do |raw_row|
      row = raw_row.map { |value| value && value.include?(";") ? value.split(";").map(&:strip) : value }
      point_id = Point.where(title: row[3])&.first&.id
      perm = row[9].blank? ? "anonymous" : "user_only"
      story = Story.create(title:row[0],
                           point_id: point_id,
                           permission_level: perm,
                           desc: row[1])
      speaker_ids = Speaker.where(name: row[2]).pluck(:id)
      speaker_ids.each do |speaker_id|
        SpeakerStory.create(story_id: story.id, speaker_id: speaker_id)
      end
      if row[8].respond_to?(:each)
        mediafiles = row[8].map { |filename| '/media/' + filename }
      else
        mediafiles = [ '/media/' + row[8].to_s ]
      end
      row[8] && mediafiles.each_with_index do |mediafile, i|
        if File.exist?(mediafile)
          file = File.open(mediafile)
          story.media.attach(io: file, filename: row[8][i])
        end
      end
      story.save
    end
  end

  enum permission_level: [:anonymous, :user_only, :editor_only]
end
