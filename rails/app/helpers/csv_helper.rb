module CsvHelper
  MEDIA_PATH = Rails.env.test? ? 'spec/fixtures/media' : 'import/media'
  def csv_importer(file_contents, type)
      error_messages = {}
      CSV.parse(file_contents, headers:true).each.with_index(1) do |row,line|
        case type.new.class.name
        when "Story"
          decorator = FileImport::StoryRowDecorator.new(row)
          object = Story.new(decorator.to_h)
          object.media.attach(decorator.media.blob_data) if decorator.media.attachable?
        when "Place"
          decorator = FileImport::PlaceRowDecorator.new(row)
          object = Place.find_or_create_by(decorator.to_h)
          object.photo.attach(decorator.media.blob_data) if decorator.media.attachable?
        when "Speaker"
          object = Speaker.find_or_create_by(name: row[0])
          object.birthplace = type.get_birthplace(row[2])
          # Assumes birth date field is always just a year
          object.birthdate = row[1].nil? || row[1].downcase == 'unknown' ? nil : Date.strptime(row[1], "%Y")
          pathname = Rails.root.join(MEDIA_PATH, row[3])
          if row[3] && File.exist?(pathname)
            file = File.open(pathname)
            object.photo.attach(io: file, filename: row[3])
          end
        else
          error_messages = "CSV importing does not working with #{type.new.class.name}"
        end
        error_messages["CSV Line #{line}"] = object.errors.full_messages if !object.save
      end
      error_messages
  end
end