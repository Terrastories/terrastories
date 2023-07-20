module Dashboard
  class SearchController < ApplicationController
    def index
      @page = SearchPage.new(current_community, search_params)
      @results = @page.data

      respond_to do |format|
        format.html
        format.json {
          render json: {
            entries: render_to_string(partial: "results", formats: [:html]),
            pagination: @page.has_next_page? ? search_url(@page.next_page_meta) : nil
          }
        }
      end
    end

    private

    def search_params
      params.permit(
        :search,
        :limit,
        :offset
      )
    end
  end
end
