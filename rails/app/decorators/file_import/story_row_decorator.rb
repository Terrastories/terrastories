class FileImport::StoryRowDecorator
  METHODS_EXCEPT = [:media, :to_h]
  def initialize(row, community)
    @row = row.map { |_, value| value.to_s }
    @community = community
  end

  def title
    at(0)
  end

  def desc
    at(1)
  end

  def speakers
    at(2).split(',').map do |speaker_name|
      Speaker.find_or_create_by(name: speaker_name.strip, community: @community)
    end
  end

  def places
    at(3).split(',').map do |place_name|
      Place.find_or_create_by(name: place_name.strip, community: @community)
    end
  end

  def interview_location
    Place.find_or_create_by(name: at(4).strip) if at(4).strip.present?
  end

  def date_interviewed
    Date.strptime(at(5).strip, "%m/%d/%y") if at(5).strip.present?
  end

  def interviewer
    Speaker.find_or_create_by(name: at(6).strip, community: @community) if at(6).strip.present?
  end

  def community
    @community
  end

  def language
    at(7).strip if at(7).present?
  end

  def media
    ::StoryMediaDecorator.new(at(8).strip)
  end

  def permission_level
    at(9).strip.blank? ? "anonymous" : "user_only"
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
