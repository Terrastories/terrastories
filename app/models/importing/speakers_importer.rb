module Importing
  class SpeakersImporter < BaseImporter
    def import_row(row)
      speaker = Speaker.find_or_create_by(name: row[0])
      speaker.birthplace = get_birthplace(row[2])
      # Assumes birth date field is always just a year
      speaker.birthdate = row[1].nil? || row[1].downcase == 'unknown' ? nil : Date.strptime(row[1], "%Y")
      if row[3] && File.exist?(Rails.root.join('media', row[3]))
        file = File.open(Rails.root.join('media',row[3]))
        speaker.photo.attach(io: file, filename: row[3])
      end
      speaker.save!
    end

    def get_birthplace(name)
      if name.nil? || name.downcase == 'unknown'
        return nil
      end
      Place.find_or_create_by(name: name)
    end
  end
end
