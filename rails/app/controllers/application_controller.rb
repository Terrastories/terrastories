class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Locale

  protect_from_forgery

  before_action :authenticate_user!
  before_action :set_community

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_community
    if offline_community?
      @community ||= Community.first
    else
      # skip if user is not authenticated
      return unless current_user

      @community ||= current_user.community
    end
  end

  helper_method :current_community
  def current_community
    @community
  end

  def offline_community?
    Rails.application.config.offline_mode
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end
end
