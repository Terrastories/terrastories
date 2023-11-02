class Api::StoriesPage < Page
  def initialize(community, meta = {})
    @community = community
    @meta = meta

    @meta[:limit] ||= 10
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "created_at"
    @meta[:sort_dir] ||= "desc"
  end

  def relation
    stories = @community.stories.joins(:places, :speakers).where(permission_level: :anonymous)

    # Filters
    stories = stories.where(places: {id: @meta[:places]}) if @meta[:places]
    stories = stories.where(places: {region: @meta[:region]}) if @meta[:region]
    stories = stories.where(places: {type_of_place: @meta[:type_of_place]}) if @meta[:type_of_place]
    stories = stories.where(topic: @meta[:topic]) if @meta[:topic]
    stories = stories.where(language: @meta[:language]) if @meta[:language]
    stories = stories.where(speakers: {id: @meta[:speakers]}) if @meta[:speakers]
    stories = stories.where(speakers: {speaker_community: @meta[:speaker_community]}) if @meta[:speaker_community]

    # Ensure distinct
    stories = stories.preload(:places, :speakers).distinct

    stories.order(@meta[:sort_by] => @meta[:sort_dir])
  end
end