class Place < ApplicationRecord
  require 'csv'
  has_many :points

  has_one_attached :photo
  validate :photo_format

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      loc = Place.where(name: row[0], type_of_place: row[1]).first_or_create
      loc.points.create(title:row[0], lat: row[5].to_f, lng: row[4].to_f, region: row[3])
    end
  end

  def photo_format
    return unless photo.attached?
    return if photo.blob.content_type.start_with? 'image/'
    photo.purge_later
    errors.add(:photo, 'needs to be an image')
  end

end
