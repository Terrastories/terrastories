class Story < ApplicationRecord
  belongs_to :point
  belongs_to :speaker
  has_many_attached :media

  acts_as_taggable

  def self.import_csv(filename)
    CSV.foreach(filename, { headers: true,
                            col_sep: ';',
                            converters: lambda { |f| f ? f.strip : nil } }) do |row|
      pointid = Point.where(title: row[3])&.first&.id
      speakerid = Speaker.where(name: row[2])&.first&.id
      perm = row[9].blank? ? "anonymous" : "user_only"
      story = Story.create(title:row[0],
                           point_id: pointid,
                           speaker_id: speakerid,
                           permission_level: perm,
                           desc: row[1])
      mediafile = '/media/' + row[8]
      if row[8] && File.exist?(mediafile)
        file = File.open(mediafile)
        story.media.attach(io: file, filename: row[8])
      end
      story.save
    end
  end

  enum permission_level: [:anonymous, :user_only, :editor_only]
end
