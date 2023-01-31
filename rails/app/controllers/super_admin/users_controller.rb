module SuperAdmin

  class UsersController < ApplicationController
    def edit
      @user = User.find(params[:id])
    end
  end
end
