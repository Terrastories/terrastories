class Story < ApplicationRecord
  belongs_to :point
  belongs_to :speaker
  has_many_attached :media

  acts_as_taggable

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      pointid = Point.where(title: row[3])&.first&.id
      speakerid = Speaker.where(name: row[2])&.first&.id
      perm = row[9].blank? ? "anonymous" : "user_only"
      Story.create(title:row[0], point_id: pointid, speaker_id: speakerid, permission_level: perm)
    end
  end

  enum permission_level: [:anonymous, :user_only, :editor_only]
end
