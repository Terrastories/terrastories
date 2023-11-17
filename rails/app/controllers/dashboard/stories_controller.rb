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

      if ActiveModel::Type::Boolean.new.cast(story_params[:story_pinned])
        community_stories.update_all(story_pinned: false)
      end

      @story = community_stories.new(story_params.except(:media))

      if @story.save
        story_params[:media]&.each do |media|
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

      if !@story.story_pinned && ActiveModel::Type::Boolean.new.cast(story_params[:story_pinned])
        community_stories.update_all(story_pinned: false)
      end

      if @story.update(story_params.except(:media))
        story_params[:media]&.each do |media|
          m = @story.media.create(media: media)
        end

        redirect_to @story
      else
        render :edit
      end
    end

    def pin
      @story = authorize community_stories.find(params[:id])
      community_stories.update_all(story_pinned: false)
      @story.update(story_pinned: true)

      redirect_to stories_path
    end

    def unpin
      @story = authorize community_stories.find(params[:id])
      @story.update(story_pinned: false)

      redirect_to stories_path
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