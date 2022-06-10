module Dashboard
  class UsersController < ApplicationController
    def index
      @users = authorize community.users
    end

    def show
      @user = authorize community.users.find(params[:id])
    end

    def edit
      @user = authorize community.users.find(params[:id])
    end

    def update
      @user = authorize community.users.find(params[:id])

      if @user.update(user_params.delete_if { |k, v| k == 'password' && v.blank? })
        redirect_to @user
      else
        @user.password = nil
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :email,
        :password,
        :role,
        :photo
      )
    end
  end
end