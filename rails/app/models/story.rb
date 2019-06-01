class Story < ApplicationRecord
  belongs_to :point
  has_many :speakers, through: :speaker_stories
  has_many_attached :media
  has_many :interview_locations, through: :places

  acts_as_taggable

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      # keep point id information in case of a rollback
      pointid = Point.where(title: row[3])&.first&.id
      speakerid = Speaker.where(name: row[2])&.first&.id
      perm = row[9].blank? ? "anonymous" : "user_only"
      story = Story.create(title:row[0], point_id: pointid, speaker_id: speakerid, permission_level: perm)
      # add place to collection that belongs to story
      related_places = Place.where(name: row[3])
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
