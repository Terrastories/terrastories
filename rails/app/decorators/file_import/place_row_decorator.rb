class FileImport::PlaceRowDecorator
  METHODS_EXCEPT = [:media, :to_h]
  def initialize(row)
    @row = row.map { |_, value| value.to_s }
  end

  def name
    at(0)
  end

  def type_of_place
    at(1)
  end

  def description
    at(2)
  end

  def region
    at(3)
  end

  def long
    at(4)
  end

  def lat
    at(5)
  end

  def media
    ::PlacePhotoDecorator.new(at(6).strip)
  end

  def to_h
    (public_methods(false) - METHODS_EXCEPT).inject({}) do |accumulator, method_name|
      accumulator[method_name] = public_send(method_name)
      accumulator
    end
  end

  private

  def at(index)
    @row[index]
  end
end
