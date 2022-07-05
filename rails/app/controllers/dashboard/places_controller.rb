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

    def new
      authorize @place = community.places.new
    end

    def create
      authorize Place
      @place = community.places.new(place_params)

      if @place.save
        redirect_to @place
      else
        render :new
      end
    end

    def show
      @place = authorize community.places.find(params[:id])
    end

    def edit
      @place = authorize community.places.find(params[:id])
    end

    def update
      @place = authorize community.places.find(params[:id])

      if @place.update(place_params)
        redirect_to @place
      else
        render :edit
      end
    end

    private

    def place_params
      params.require(:place).permit(
        :name,
        :description,
        :photo,
        :name_audio,
        :type_of_place,
        :region,
        :lat,
        :long,
        story_ids: []
      )
    end
  end
end