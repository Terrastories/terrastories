module Dashboard
  class PlacesController < ApplicationController
    def index
      @places = community.places
    end

    def show
      @place = community.places.find(params[:id])
    end
  end
end