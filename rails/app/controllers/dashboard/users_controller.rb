module Dashboard
  class UsersController < ApplicationController
    def index
      authorize community.users

      @page = UsersPage.new(community, params)
      @users = @page.data

      respond_to do |format|
        format.html
        format.json {
          render json: {
            entries: render_to_string(partial: "users", formats: [:html]),
            pagination: @page.has_next_page? ? users_url(@page.next_page_meta) : nil
          }
        }
      end
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