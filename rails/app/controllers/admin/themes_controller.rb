require 'pry'
module Admin
  class ThemesController < Admin::ApplicationController
    def create
      if theme_params[:active]
        deactivate_prev_theme
      end
      super
    end

    def update
      if theme_params[:active]
        deactivate_prev_theme
      end
      super
    end
    
    def deactivate_prev_theme
      prev = Theme.find_by(active: true)
      prev.update(active: false)
    end

    def theme_params
      params.require(:theme).permit(:active)
    end
  end
end
