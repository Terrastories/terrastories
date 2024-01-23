module SuperAdmin
  class UsersController < ApplicationController
    def edit
      @user = User.find(params[:id])

      if @user.role == 'admin'
        @user
      else
        flash[:alert] = 'You are not authorized to perform this action.'
        redirect_to(root_path)
      end
    end

    def update
      @user = User.find(params[:id])
      if @user.role != 'admin'
        redirect_to(root_path)
      elsif @user.update(user_params)
        redirect_to edit_member_path(@user), notice: 'User successfully updated'
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :password,
      )
    end
  end
end
