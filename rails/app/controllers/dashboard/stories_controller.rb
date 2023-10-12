module Dashboard
  class StoriesController < BaseController
    def index
      @page = StoriesPage.new(community_stories, filter_params)
      @stories = @page.data

      respond_to do |format|
        format.html
        format.json {
          render json: {
            entries: render_to_string(partial: "stories", formats: [:html]),
            pagination: @page.has_next_page? ? stories_url(@page.next_page_meta) : nil
          }
        }
      end
    end

    def new
      authorize @story = community_stories.new
    end

    def create
      authorize Story
      @story = community_stories.new(story_params.except(:media))

      if @story.save
        story_params[:media].each do |media|
          m = @story.media.create(media: media)
        end
        redirect_to @story
      else
        render :new
      end
    end

    def show
      @story = authorize community_stories.find(params[:id])
    end

    def edit
      @story = authorize community_stories.find(params[:id])
    end

    def update
      @story = authorize community_stories.find(params[:id])
      @stories = community_stories.all

      if params[:story_pinned].present?
        if params[:story_pinned]
          @stories.update_all(story_pinned: !params[:story_pinned])
        end

        @story.update(story_pinned: params[:story_pinned])

        return redirect_to action: "index"
      end

      if story_params[:story_pinned].present?
        if story_params[:story_pinned]
          @stories.update_all(story_pinned: !story_params[:story_pinned])
        end

        @story.update(story_pinned: story_params[:story_pinned])

        render :edit
      elsif @story.update(story_params.except(:media))
        story_params[:media].each do |media|
          m = @story.media.create(media: media)
        end

        redirect_to @story
      else
        render :edit
      end
    end

    def destroy
      @story = authorize community_stories.find(params[:id])

      @story.destroy

      redirect_to stories_path
    end

    def delete_media
      @story = authorize community_stories.find(params[:story_id])

      media = @story.media.find(params[:id])
      media.destroy

      head :ok
    end

    private

    def community_stories
      policy_scope(current_community.stories)
    end

    def story_params
      params.require(:story).permit(
        :title,
        :desc,
        :date_interviewed,
        :language,
        :permission_level,
        :topic,
        :interview_location_id,
        :interviewer_id,
        :story_pinned,
        media: [],
        speaker_ids: [],
        place_ids: []
      )
    end

    def filter_params
      params.permit(
        :place,
        :speaker,
        :visibility,
        :limit,
        :offset
      )
    end
  end
end