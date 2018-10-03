class Place < ApplicationRecord
  require 'csv'
  has_many :points

  def self.import_csv(filename)
    CSV.parse(filename, headers: true) do |row|
      loc = Place.where(name: row[0], type_of_place: row[1]).first_or_create
      loc.points.create(title:row[0], lat: row[5].to_f, lng: row[4].to_f, region: row[3] )
    end
  end

end
