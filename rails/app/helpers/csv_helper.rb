module CsvHelper
    def csv_importer(file_contents, type)
        error_messages = {}
        CSV.parse(file_contents, headers:true).each.with_index(1) do |row,line|
          case type.new.class.name
          when "Story"
            decorator = FileImport::StoryRowDecorator.new(row)
            object = Story.new(decorator.to_h)
          end
          object.media.attach(decorator.media.blob_data) if decorator.media.attachable?
          error_messages["CSV Line #{line}"] = object.errors.full_messages if !object.save
        end
        error_messages
    end
end
 