module Onboard
  class CommunityController < BaseController
    def show
      @community = Community.new
    end

    def create
      @community = Community.new(community_params)

      if @community.save
        current_user.update(community: @community)
        redirect_to root_path
      else
        render :show
      end
    end

    def community_params
      params.require(:community).permit(
        :name, :locale, :country
      )
    end
  end
end
