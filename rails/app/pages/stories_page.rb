class StoriesPage < Page
  def initialize(community, meta = {})
    @community = community
    @meta = meta

    @meta[:limit] ||= 10
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "created_at"
    @meta[:sort_dir] ||= "desc"
  end

  def relation
    stories = @community.stories

    stories = stories.joins(:places).where(places: {id: @meta[:place]}) if @meta[:place].present?
    stories = stories.joins(:speakers).where(speakers: {id: @meta[:speaker]}) if @meta[:speaker].present?
    stories = stories.where(permission_level: @meta[:visibility]) if @meta[:visibility].present?

    stories.order(@meta[:sort_by] => @meta[:sort_dir])
  end
end