module Dashboard
  class ApplicationController < ActionController::Base
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :not_authorized

    layout "dashboard"

    before_action :authenticate_user!
    before_action :set_locale

    def default_url_options
      { locale: params[:locale] || I18n.locale }
    end

    protected

    def not_authorized
      flash.alert = "You are not authorized to perform this action"
      redirect_to root_path
    end

    private

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    helper_method :community
    def community
      @community ||= current_user.community
    end
  end
end
