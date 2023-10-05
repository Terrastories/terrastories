module Api
  class StoriesController < BaseController
    def index
      community = Community.where(public: true).find_by!(slug: params[:community_id])
      @page = Api::StoriesPage.new(community, story_params)

      @stories = @page.data

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
        :sort_by,
        :sort_dir,
        :limit,
        :offset,
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
