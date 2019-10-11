module Importing
  class PlacesImporter < BaseImporter
    def import_row(row)
      place = Place.find_or_create_by(name: row[0])
      place.type_of_place = row[1]
      place.description = row[2]
      place.region = row[3]
      place.lat = row[4].to_f
      place.long = row[5].to_f

      if row[6] && File.exist?(Rails.root.join('media', row[6]))
        file = File.open(Rails.root.join('media',row[6]))
        place.photo.attach(io: file, filename: row[6])
      end

      place.save!
    end
  end
end
