class PlacesPage < Page
  def initialize(scoped_places, meta = {})
    @scoped_places = scoped_places
    @meta = meta

    @meta[:limit] ||= 20
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "created_at"
    @meta[:sort_dir] ||= "desc"
  end

  def relation
    places = @scoped_places

    places.order(@meta[:sort_by] => @meta[:sort_dir])
  end
end