module Dashboard
  class CommunitiesController < ApplicationController
    def show
      @community = authorize current_user.community
    end

    def update
      @community = authorize current_user.community

      @community.update(community_params)

      redirect_to community_settings_path
    end

    private

    def community_params
      params.require(:community).permit(
        :beta,
        :public,
        :background_img,
        sponsor_logos: []
      )
    end
  end
end
