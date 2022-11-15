module Onboard
  class AccountController < BaseController
    def show
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.role = :admin

      if @user.save
        sign_in(@user)
        redirect_to onboard_community_path
      else
        render :show
      end
    end

    def user_params
      params.require(:user).permit(
        :name, :username, :password
      )
    end
  end
end
