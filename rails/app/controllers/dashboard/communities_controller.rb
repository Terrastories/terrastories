module Dashboard
  class CommunitiesController < ApplicationController
    def show
      @community = authorize current_user.community
    end

    def update
      @community = authorize current_user.community

      @community.update(community_params)
    end

    private

    def community_params
      params.require(:community).permit(
        :beta
      )
    end
  end
end
