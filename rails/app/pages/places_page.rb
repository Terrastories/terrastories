class PlacesPage < Page
  def initialize(community, meta = {})
    @community = community
    @meta = meta

    @meta[:limit] ||= 20
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "created_at"
    @meta[:sort_dir] ||= "desc"
  end

  def relation
    places = @community.places

    places.order(@meta[:sort_by] => @meta[:sort_dir])
  end
end