class StoriesPage < Page
  def initialize(scoped_stories, meta = {})
    @scoped_stories = scoped_stories
    @meta = meta

    @meta[:limit] ||= 10
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "created_at"
    @meta[:sort_dir] ||= "desc"
  end

  def relation
    stories = @scoped_stories

    stories = stories.joins(:places_stories).where(places_stories: {place_id: @meta[:place]}) if @meta[:place].present?
    stories = stories.joins(:speaker_stories).where(speaker_stories: {speaker_id: @meta[:speaker]}) if @meta[:speaker].present?
    stories = stories.where(permission_level: @meta[:visibility]) if @meta[:visibility].present?

    stories = stories.order(@meta[:sort_by_pinned] => @meta[:sort_dir])
    stories.order(
      @meta[:sort_by] => @meta[:sort_dir],
      story_pinned: :desc
    )
  end
end
