module Admin
  class ThemesController < Admin::ApplicationController
    def delete
      remove_attachment
    end

    private

    def remove_attachment
      logo = ActiveStorage::Attachment.find(params[:attachment_id])
      logo.purge
      redirect_back(fallback_location: "/")
    end
  end
end
