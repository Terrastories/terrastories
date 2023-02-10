module Api
  class PlacesController < BaseController
    def show
      community = Community.where(public: true).find_by!(slug: params[:community_id])
      @place = community.places.find(params[:id])
    end
  end
end
