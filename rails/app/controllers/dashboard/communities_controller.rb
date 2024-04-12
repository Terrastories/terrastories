module Dashboard
  class CommunitiesController < BaseController
    def show
      @community = authorize current_user.community
    end

    def update
      @community = authorize current_user.community

      @community.update(community_params)

      # Append new sponsor logos
      if file_uploads.present?
        file_uploads[:sponsor_logos].each do |logo|
          @community.sponsor_logos.attach(io: logo, filename: logo.original_filename)
        end
      end

      if @community.public? && @community.theme.mapbox_token.present?
        static_map_url = if @community.theme.boundaries
          "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/#{@community.theme.boundaries.flatten.to_s.gsub(' ','').sub("[", "%5B").sub("]", "%5D")}/900x600?access_token=#{@community.theme.mapbox_token}"
        else
          "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/#{@community.theme.center_long},#{@community.theme.center_lat},#{@community.theme.zoom},#{@community.theme.bearing},#{@community.theme.pitch}/900x600?access_token=#{@community.theme.mapbox_token}"
        end
        begin
          @community.theme.static_map.attach(io: URI.open(static_map_url), filename: "#{@community.slug}-static-map.png")
        rescue StandardError
          # do nothing; no worries if we can't save the map
        end
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
        :description
      )
    end

    def file_uploads
      params.require(:community).permit(sponsor_logos: [])
    end
  end
end
