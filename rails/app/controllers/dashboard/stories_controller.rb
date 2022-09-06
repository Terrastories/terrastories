module Dashboard
  class StoriesController < ApplicationController
    def index
      @page = StoriesPage.new(community, filter_params)
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
      authorize @story = community.stories.new
    end

    def create
      authorize Story
      @story = community.stories.new(story_params)

      if @story.save
        redirect_to @story
      else
        render :new
      end
    end

    def show
      @story = authorize community.stories.find(params[:id])
    end

    def edit
      @story = authorize community.stories.find(params[:id])
    end

    def update
      @story = authorize community.stories.find(params[:id])

      if @story.update(story_params)
        redirect_to @story
      else
        render :edit
      end
    end

    def destroy
      @story = authorize community.stories.find(params[:id])

      @story.destroy

      redirect_to stories_path
    end

    private

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