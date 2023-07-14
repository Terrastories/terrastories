module Dashboard
  class ThemesController < BaseController
    def edit
      @theme = current_community.theme
    end

    def show
      redirect_to edit_theme_path
    end

    def update
      @theme = current_community.theme
      if @theme.update(theme_params)
        if current_community.public
          static_map_url = if @theme.boundaries
            "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/#{@theme.boundaries.flatten.to_s.gsub(' ','').sub("[", "%5B").sub("]", "%5D")}/900x600?access_token=#{@theme.mapbox_token}"
          else
            "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/#{@theme.center_long},#{@theme.center_lat},#{@theme.zoom},#{@theme.bearing},#{@theme.pitch}/900x600?access_token=#{@theme.mapbox_token}"
          end
          @theme.static_map.attach(io: URI.parse(static_map_url).open, filename: "#{current_community.slug}-static-map.png")
        end
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
