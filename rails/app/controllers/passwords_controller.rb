class PasswordsController < ApplicationController
  layout "dashboard"

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(password_params)
      flash.notice = t("devise.passwords.updated_not_active")
      if @user.super_admin
        redirect_to super_admin_root_path
      elsif @user.community.present?
        redirect_to member_root_path
      else
        redirect_to root_path
      end
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
