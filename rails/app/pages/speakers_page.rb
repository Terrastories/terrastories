class SpeakersPage < Page
  def initialize(community, meta = {})
    @community = community
    @meta = meta

    @meta[:limit] ||= 20
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "name"
    @meta[:sort_dir] ||= "asc"
  end

  def relation
    speakers = @community.speakers

    speakers.order(@meta[:sort_by] => @meta[:sort_dir])
  end
end