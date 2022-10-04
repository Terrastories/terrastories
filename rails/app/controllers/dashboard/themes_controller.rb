module Dashboard
  class ThemesController < ApplicationController
    def edit
      @theme = community.theme
    end

    def show
      redirect_to edit_theme_path
    end

    def update
      @theme = community.theme
      if @theme.update(theme_params)
        redirect_to edit_theme_path
      else
        render :edit
      end
    end

    def delete_background_img
      @theme = community.theme
      @theme.background_img.purge

      head :ok
    end

    def delete_sponsor_logo
      @theme = community.theme
      logo_blob = @theme.sponsor_logos.blobs.find_signed(params[:id])
      logo_blob.attachments.each(&:purge)

      head :ok
    end

    private

    def theme_params
      params.require(:theme).permit(
        :background_img,
        :mapbox_style_url,
        :mapbox_access_token,
        :mapbox_3d,
        :center_lat,
        :center_long,
        :sw_boundary_lat,
        :sw_boundary_long,
        :ne_boundary_lat,
        :ne_boundary_long,
        :zoom,
        :pitch,
        :bearing,
        :map_projection,
        sponsor_logos: []
      )
    end
  end
end
