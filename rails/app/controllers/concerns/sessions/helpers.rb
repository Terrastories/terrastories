module Sessions::Helpers
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    helper_method :user_signed_in?
  end

  def authenticate_user!
    if !user_signed_in?
      flash[:alert] = t("devise.failure.unauthenticated")
      redirect_to login_path
    end
  end

  private

  def user_signed_in?
    current_user.present?
  end

  # Define the current_user method:
  def current_user
    # Look up the current user based on user_id in the session cookie:
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end