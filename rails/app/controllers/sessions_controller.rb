class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    # render login form
  end

  # Create session
  def create
    user = User.where(username: login_params[:login]).or(User.where(email: login_params[:login])).first

    if session[:user_id] == user&.id
      redirect_to root_path, notice: t("devise.failure.already_authenticated")
    elsif user.authenticate(login_params[:password])
      session[:user_id] = user.id
      user.update_tracked_fields(request)
      redirect_to root_path, notice: t("devise.sessions.signed_in")
    else
      flash.now.alert = t("devise.failure.not_found_in_database", authentication_keys: "login")
      render :new
    end
  end

  # Delete sessions
  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: t("devise.sessions.signed_out")
  end

  private

  def login_params
    params.require(:user).permit(:login, :password)
  end
end