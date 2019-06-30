class Story < ApplicationRecord
  has_many :speaker_stories
  has_many :speakers, through: :speaker_stories
  has_many_attached :media
  has_and_belongs_to_many :places
  belongs_to :interview_location, class_name: "Place", foreign_key: "interview_location_id"
  belongs_to :interviewer, class_name: "Speaker", foreign_key: "interviewer_id"

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      story = Story.new(title: row[0])
      story.desc = row[1]
      # add each spaker to the story, split by comma
      speaker_names = row[2]
      speaker_names.split(',').each do |speaker|
        story.speakers << Speaker.find_or_create_by(name: speaker.strip)
      end
      # add each place to the story, split by comma
      place_names = row[3]
      place_names.split(',').each do |place|
        story.places << Place.find_or_create_by(name: place.strip)
      end
      # Add interview location
      story.interview_location = row[4].blank? ? nil : Place.find_or_create_by(name: row[4])
      # Add interview date
      story.date_interviewed = row[5].blank? ? nil : Date.strptime(row[5], "%m/%d/%y")
      # Add interviewer
      story.interviewer = row[6].blank? ? nil : Speaker.find_or_create_by(name: row[6])
      # Add Language
      story.language = row[7].blank? ? nil : row[7]
      if row[8] && File.exist?(Rails.root.join('media', row[8]))
        file = File.open(Rails.root.join('media',row[8]))
        story = Story.new
        story.media.attach(io: file, filename: row[8])
      end
      story.permission_level = row[9].blank? ? "anonymous" : "user_only"
      story.save
    end
  end

  enum permission_level: [:anonymous, :user_only, :editor_only]
end
