require 'csv'

module Importing
  class BaseImporter
    def initialize(data)
      @data = data
    end

    def import
      ActiveRecord::Base.transaction do
        CSV.parse(@data, headers: true) do |row|
          import_row(row)
        end
      rescue StandardError => e
        raise ImportError.new(e.message)
      end
    end

    def import_row(row); end
  end
end
