class ApplicationController < ActionController::Base
  include Pundit::Authorization
  protect_from_forgery

  before_action :authenticate_user!
  before_action :set_locale
  before_action :set_community

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def default_url_options
    { locale: set_locale }
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_community
    # skip if user is not authenticated
    return unless current_user

    @community ||= current_user.community
  end

  def current_community
    @community
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end
end
