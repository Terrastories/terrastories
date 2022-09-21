class SpeakersPage < Page
  def initialize(scoped_speakers, meta = {})
    @scoped_speakers = scoped_speakers
    @meta = meta

    @meta[:limit] ||= 20
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "name"
    @meta[:sort_dir] ||= "asc"
  end

  def relation
    speakers = @scoped_speakers

    speakers.order(@meta[:sort_by] => @meta[:sort_dir])
  end
end