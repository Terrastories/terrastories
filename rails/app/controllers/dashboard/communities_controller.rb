module Dashboard
  class CommunitiesController < BaseController
    def show
      @community = authorize current_user.community
    end

    def update
      @community = authorize current_user.community

      @community.update(community_params)
      if @community.public
        static_map_url = if @community.theme.boundaries
          "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/#{@community.theme.boundaries.flatten.to_s.gsub(' ','').sub("[", "%5B").sub("]", "%5D")}/900x600?access_token=#{@community.theme.mapbox_token}"
        else
          "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/#{@community.theme.center_long},#{@community.theme.center_lat},#{@community.theme.zoom},#{@community.theme.bearing},#{@community.theme.pitch}/900x600?access_token=#{@community.theme.mapbox_token}"
        end
        @community.theme.static_map.attach(io: URI.parse(static_map_url).open, filename: "#{@community.slug}-static-map.png")
      end

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
        :description,
        sponsor_logos: []
      )
    end
  end
end
