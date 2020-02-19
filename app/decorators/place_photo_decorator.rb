class PlacePhotoDecorator
  def initialize(filename)
    @filename = filename
  end

  def attachable?
    File.exist?(path)
  end

  def blob_data
    if attachable?
      {io: File.open(path), filename: @filename}
    end
  end

  private

  def path
    Rails.root.join(::Place::MEDIA_PATH,  @filename)
  end
end
