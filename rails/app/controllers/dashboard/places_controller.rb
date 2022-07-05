module Dashboard
  class PlacesController < ApplicationController
    def index
      @page = PlacesPage.new(community, params)
      @places = @page.data

      respond_to do |format|
        format.html
        format.json {
          render json: {
            entries: render_to_string(partial: "places", formats: [:html]),
            pagination: @page.has_next_page? ? places_url(@page.next_page_meta) : nil
          }
        }
      end
    end

    def show
      @place = community.places.find(params[:id])
    end
  end
end