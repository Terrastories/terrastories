module Dashboard
  class ApplicationController < ActionController::Base
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    layout "dashboard"

    before_action :authenticate_user!
    before_action :set_locale

    def default_url_options
      { locale: params[:locale] || I18n.locale }
    end

    protected

    def not_authorized
      flash.alert = "You are not authorized to perform this action"
      redirect_to member_root_path
    end

    def not_found
      flash.alert = "The resource you requested cannot be found"
      redirect_to member_root_path
    end

    private

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    helper_method :community
    def community
      @community ||= current_user.community
    end

    def meta_params
      params.permit(
        :limit,
        :offset
      )
    end
  end
end
