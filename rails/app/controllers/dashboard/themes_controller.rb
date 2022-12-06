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

    private

    def theme_params
      params.require(:theme).permit(
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
        community_attributes: [
          :id,
          :background_img,
          sponsor_logos: []
        ]
      )
    end
  end
end
