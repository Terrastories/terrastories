class Story < ApplicationRecord
  has_many :speaker_stories
  has_many :speakers, through: :speaker_stories
  has_many_attached :media
  has_and_belongs_to_many :places
  belongs_to :interview_location, class_name: "Place", foreign_key: "interview_location_id"
  belongs_to :interviewer, class_name: "Speaker", foreign_key: "interviewer_id"

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      perm = row[9].blank? ? "anonymous" : "user_only"
      story = Story.find_or_create_by(title: row[0], desc: row[1], permission_level: perm)
      speaker_names = row[2]
      speakers = []
      speaker_names.split(',').each do |speaker|
        story.speakers << Speaker.find_or_create_by(name: speaker.strip)
      end
      # add place to collection that belongs to story
      place_names = row[3]
      place_names.split(',').each do |place|
        story.places << Place.find_or_create_by(name: place.strip)
      end
      # Add interviewer
      story.interviewer = Speaker.find_or_create_by(name: row[6])
      # Add Language
      story.language = row[7]
      # Add interview location
      story.interview_location = Place.find_or_create_by(name: row[4])
      if row[8] && File.exist?(Rails.root.join('media', row[8]))
        file = File.open(Rails.root.join('media',row[8]))
        story.media.attach(io: file, filename: row[8])
        story.save
      end
      story.save
    end
  end

  enum permission_level: [:anonymous, :user_only, :editor_only]
end
