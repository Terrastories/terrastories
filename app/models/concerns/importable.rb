module Importable
  extend ActiveSupport::Concern

  class_methods do
    def importer(importer_klass)
      @importer_klass = importer_klass
    end

    def import(data)
      @importer_klass.new(data).import
    end
  end
end
