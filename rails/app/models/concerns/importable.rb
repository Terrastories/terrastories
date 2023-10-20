module Importable
  extend ActiveSupport::Concern
  require 'csv'

  EXCLUDE_ATTRIBUTES_FROM_IMPORT = []
  IMPORT_PATH = "import/media/"

  class_methods do
    def csv_headers
      database_attribute_names +
      associated_attribute_names +
      attachment_attribute_names
    end

    def database_attribute_names
      # attribute_names returns strings; so we need to convert them to symbols
      self.attribute_names.map(&:to_sym) - excluded_attributes
    end

    def associated_attribute_names
      self.reflect_on_all_associations.select! { |r| [:has_many, :has_and_belongs_to_many].include?(r.macro) }.map { |a| a.name } - excluded_attributes
    end

    def attachment_attribute_names
      self.reflect_on_all_attachments.map { |a| a.name } - excluded_attributes
    end

    def excluded_attributes
      %i[id community_id created_at updated_at] + self::EXCLUDE_ATTRIBUTES_FROM_IMPORT
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
      raise HeaderMismatchError unless (@mapped_headers.values.reject(&:blank?) - headers).empty?
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

        # Remove nil keys (columns with values that do not have mapped headers)
        attrs.reject! { |k, _| k.nil? }

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

    def attach_files(k, attachment, filename)
      path = filename.dup.insert(0, IMPORT_PATH)
      if filename && File.exist?(path)
        k.send(attachment).attach(io: File.open(path), filename: filename)
      end
    end

    def save_importable_records
      importable_rows.each do |row|
        # with_indifferent_access to allow key access as strings or symbols
        # since CSV uses strings and AR uses symbols.
        attributes = row.dup.with_indifferent_access

        # Remove media from attributes to attach later.
        media = @klass.attachment_attribute_names.each_with_object({}) do |k, hash|
          value = attributes.delete(k)
          next if value.nil?

          hash[k] = value
        end

        # Story Media Association
        # This must be after attachment attributes to ensure files are correctly
        # matched when "media" is used for attachment key.
        if attributes["media"].present?
          story_media = attributes.delete("media")
        end

        # Find or create has_many* relationships
        @klass.associated_attribute_names.each do |association|
          next if association == :media

          values = attributes[association].to_s.split(",")
          attributes[association] = values.map do |name|
            association.to_s.singularize.classify.constantize.find_or_create_by(name: name.strip, community_id: @community_id)
          end
        end

        # Find or create belongs_to relationships
        @klass.reflect_on_all_associations.select! { |r| [:belongs_to].include?(r.macro) }.map { |r| [r.foreign_key.to_sym, r.class_name] }.each do |belongs_to_association, klass_name|
          next unless attributes[belongs_to_association].present?
          attributes[belongs_to_association] = klass_name.constantize.find_or_create_by(name: attributes[belongs_to_association].strip, community_id: @community_id).id
        end

        # Convert permissions if class headers includes `permission_level`
        # NOTE(@lauramosher): this was pulled from the old implementation; as we think about more
        # granulated story permissions, we may want to expand this conversion
        if @mapped_headers.keys.include?("permission_level")
          attributes[:permission_level] = attributes[:permission_level]&.strip.blank? ? "anonymous" : "user_only"
        end

        record = @klass.new(attributes.merge(community_id: @community_id))
        if record.save
          media.each do |attachment, filenames|
            filenames.split(",").each do |filename|
              attach_files(record, attachment, filename)
            end
          end

          if story_media
            story_media.split(",").each do |filename|
              sm = record.media.new
              attach_files(sm, "media", filename)
              sm.save if sm.media.attached?
            end
          end
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
