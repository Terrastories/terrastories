module Dashboard
  class StoriesController < ApplicationController
    def index
      @page = StoriesPage.new(community, params)
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

    def show
      @story = community.stories.find(params[:id])
    end
  end
end