module Dashboard
  class ProfileController < ApplicationController
    def edit
      @user = current_user
    end

    def update
      @user = current_user

      if @user.update(profile_params)
        flash.notice = t("devise.registrations.updated")
        redirect_to profile_path
      else
        render :edit
      end
    end

    private

    def profile_params
      params.require(:user).permit(
        :name,
        :username,
        :email,
        :photo
      )
    end
  end
end
