class Story < ApplicationRecord
  has_many :speaker_stories
  has_many :speakers, through: :speaker_stories
  has_many_attached :media
  has_and_belongs_to_many :places
  belongs_to :place
  alias_attribute :interview_location, :place

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      # todo: update point_id here
      perm = row[9].blank? ? "anonymous" : "user_only"
      story = Story.create(title: row[0], point_id: 1)
      speakers = Speaker.find_or_create_by(name: row[2])
      story.speakers << speakers
      # add place to collection that belongs to story
      related_places = Place.find_or_create_by(name: row[3])
      story.places << related_places
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
