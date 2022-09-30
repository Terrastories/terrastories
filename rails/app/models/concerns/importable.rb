module Importable
  extend ActiveSupport::Concern

  EXCLUDE_ATTRIBUTES_FROM_IMPORT = []
  IMPORT_PATH = "import/media/"

  class_methods do
    def csv_headers
      self.attribute_names + associated_attribute_names + attachment_attribute_names - excluded_attributes
    end

    def associated_attribute_names
      self.reflect_on_all_associations.select! { |r| [:has_many, :has_and_belongs_to_many].include?(r.macro) }.map { |a| a.name.to_s } - excluded_attributes
    end

    def attachment_attribute_names
      self.reflect_on_all_attachments.map { |a| a.name.to_s } - excluded_attributes
    end

    def excluded_attributes
      ["id", "community_id", "created_at", "updated_at"] + self::EXCLUDE_ATTRIBUTES_FROM_IMPORT
    end

    def import(filename, community_id, mapped_headers)
      FileImporter.import(self, community_id, filename, mapped_headers)
    end
  end

  class FileImporter
    def self.import(klass, community_id, file, mapped_headers)
      new(klass, community_id, file, mapped_headers).import
    end

    class HeaderMismatchError < StandardError; end
    attr_accessor :duplicated_rows, :skipped_rows,
                  :invalid_rows

    def initialize(klass, community_id, file, mapped_headers)
      @file = file
      @klass = klass
      @community_id = community_id
      @mapped_headers = mapped_headers

      self.duplicated_rows = []
      self.skipped_rows = []
      self.invalid_rows = []

      @importable_rows = []
      @successful_rows = []
    end

    def import
      raise HeaderMismatchError unless (headers - @mapped_headers.values.reject(&:blank?)).empty?
      parse
      save_importable_records

      {
        duplicated_rows: duplicated_rows,
        skipped_rows: skipped_rows,
        invalid_rows: invalid_rows,
        successful: importable_rows.size - invalid_rows.size
      }
    end

    private

    attr_accessor :successful_rows, :importable_rows

    def headers
      CSV.open(@file, 'r', headers: true) do |csv|
        csv.first.headers
      end
    end

    def parse
      CSV.foreach(@file, headers: true) do |row|

        attrs = Hash[row.headers.map { |h| @mapped_headers.key(h) }.zip(row.fields)]

        # dupes
        if @klass.exists?(attrs.first[0] => attrs.first[1], community_id: @community_id)
          duplicated_rows << attrs
          next
        end

        # identical rows
        if importable_rows.include? attrs
          skipped_rows << attrs
          next
        end

        # a-ok to import
        importable_rows << attrs
      end
    end

    def save_importable_records
      importable_rows.each do |row|
        attributes = row.dup

        media = @klass.attachment_attribute_names.each_with_object({}) do |k, hash|
          value = attributes.delete(k)
          next if value.nil?

          hash[k] = value
        end

        associations = @klass.associated_attribute_names.each do |association|
          values = attributes[association].split(",")
          attributes[association] = values.map do |name|
            association.singularize.classify.constantize.find_or_create_by(name: name, community_id: @community_id)
          end
        end

        if attributes["permission_level"].present?
          attributes["permission_level"] = attributes["permission_level"].strip.blank? ? "anonymous" : "user_only"
        end

        record = @klass.new(attributes.merge(community_id: @community_id))

        if record.valid?
          media.each do |attachment, filenames|
            filenames.split(",").each do |filename|
              path = filename.dup.insert(0, IMPORT_PATH)
              if filename && File.exist?(path)
                record.send(attachment).attach(io: File.open(path), filename: filename)
              end
            end
          end
          record.save
        else
          invalid_rows << {
            attributes: row,
            errors: record.errors
          }
        end
      end
    end
  end
end
