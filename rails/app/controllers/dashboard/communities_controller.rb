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

    def delete_background_img
      @community = authorize current_user.community, :delete_attachments?
      @community.background_img.purge

      head :ok
    end

    def delete_display_image
      @community = authorize current_user.community, :delete_attachments?
      @community.display_image.purge

      head :ok
    end

    def delete_sponsor_logo
      @community = authorize current_user.community, :delete_attachments?
      logo_blob = @community.sponsor_logos.blobs.find_signed(params[:id])
      logo_blob.attachments.each(&:purge)

      head :ok
    end

    private

    def community_params
      params.require(:community).permit(
        :beta,
        :public,
        :background_img,
        :display_image,
        sponsor_logos: []
      )
    end
  end
end
