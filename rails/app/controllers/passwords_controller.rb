class PasswordsController < ApplicationController
  layout "dashboard"

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(password_params)
      bypass_sign_in(@user)
      flash.notice = t("devise.passwords.updated_not_active")
      redirect_to root_path
    else
      @user.password = nil
      @user.password_confirmation = nil
      render :edit
    end
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end
end
