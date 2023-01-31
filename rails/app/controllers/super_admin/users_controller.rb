module SuperAdmin
  class UsersController < ApplicationController
    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])

      if @user.update(user_params)
        redirect_to edit_member_path(@user), notice: "User successfully updated"
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :name,
        :username,
        :email,
        :password,
        :password_confirmation,
        :role,
        :photo
      )
    end
  end
end
