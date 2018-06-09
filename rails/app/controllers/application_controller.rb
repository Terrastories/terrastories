class ApplicationController < ActionController::Base
  include Pundit
  # setting up locale action

  before_action :set_locale

  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
 
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = I18n.available_locales.include?(locale) ?
      locale :
      I18n.default_locale
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end
end
