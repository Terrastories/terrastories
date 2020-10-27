module Admin  
  class ThemesController < Admin::ApplicationController
    def create
      if theme_params[:active] == "1"
        deactivate_prev_theme
      end
      super
    end

    def update
      if theme_params[:active] == "1"
        deactivate_prev_theme
      end
      super
    end

    def delete
      remove_attachment
    end

    def deactivate_prev_theme
      Theme.where(active: true).update_all(active: false)
    end

    def theme_params
      params.require(:theme).permit(:active, logos: [], community_logos: [])
    end

    private
      def remove_attachment
        logo = ActiveStorage::Attachment.find(params[:attachment_id])
        logo.purge
        redirect_back(fallback_location: "/")
      end
  end
end
