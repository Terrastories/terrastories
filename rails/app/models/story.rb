class Story < ApplicationRecord
  belongs_to :point
  belongs_to :speaker
  has_and_belongs_to_many :demographic
  has_many_attached :media

  acts_as_taggable

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      pointid = Point.where(title: row[3])&.first&.id
      speakerid = Speaker.where(name: row[2])&.first&.id
      story = Story.create(
        title:row[0],
        point_id: pointid,
        speaker_id: speakerid,
        is_public: row[9].blank?
      )
      if row[8] && File.exist?(Rails.root.join('media', row[8]))
        file = File.open(Rails.root.join('media',row[8]))
        story.media.attach(io: file, filename: row[8])
        story.save
      end
    end
  end

  enum permission_level: [:anonymous, :user_only, :editor_only]
end
