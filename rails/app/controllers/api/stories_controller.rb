module Api
  class StoriesController < BaseController
    def index
      community = Community.where(public: true).find_by!(slug: params[:community_id])
      @stories = community.stories.joins(:places, :speakers).where(permission_level: :anonymous).preload(:places, :speakers)

      # Filters
      @stories = @stories.where(places: {id: story_params[:places]}) if story_params[:places]
      @stories = @stories.where(places: {region: story_params[:region]}) if story_params[:region]
      @stories = @stories.where(places: {type_of_place: story_params[:type_of_place]}) if story_params[:type_of_place]
      @stories = @stories.where(topic: story_params[:topic]) if story_params[:topic]
      @stories = @stories.where(language: story_params[:language]) if story_params[:language]
      @stories = @stories.where(speakers: {id: story_params[:speakers]}) if story_params[:speakers]
      @stories = @stories.where(speakers: {speaker_community: story_params[:speaker_community]}) if story_params[:speaker_community]

      # Ensure distinct
      @stories = @stories.distinct
    end

    def show
      community = Community.where(public: true).find_by!(slug: params[:community_id])
      @story = community.stories.where(permission_level: :anonymous).preload(:places, :speakers).find(params[:id])
    end

    private

    def story_params
      params.permit(
        places: [],
        region: [],
        topic: [],
        type_of_place: [],
        language: [],
        speakers: [],
        speaker_community: [],
      )
    end
  end
end
