module Dashboard
  class PlacesController < ApplicationController
    def index
      @page = PlacesPage.new(community_places, params)
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
      authorize @place = community_places.new
    end

    def create
      authorize Place
      @place = community_places.new(place_params)

      if @place.save
        redirect_to @place
      else
        render :new
      end
    end

    def show
      @place = authorize community_places.find(params[:id])
    end

    def edit
      @place = authorize community_places.find(params[:id])
    end

    def update
      @place = authorize community_places.find(params[:id])

      if @place.update(place_params)
        redirect_to @place
      else
        render :edit
      end
    end

    def destroy
      @place = authorize community_places.find(params[:id])

      @place.destroy

      redirect_to places_path
    end

    def delete_photo
      @place = authorize community_places.find(params[:place_id])
      @place.photo.purge

      head :ok
    end

    def delete_name_audio
      @place = authorize community_places.find(params[:place_id])
      @place.name_audio.purge

      head :ok
    end

    private

    def community_places
      policy_scope(community.places)
    end

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