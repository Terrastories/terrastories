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

    def new
      @user = authorize community.users.new
    end

    def create
      authorize User
      @user = community.users.new(user_params)

      if @user.save
        redirect_to @user
      else
        @user.password = nil
        render :new
      end
    end

    def show
      @user = authorize community.users.find(params[:id])
    end

    def edit
      @user = authorize community.users.find(params[:id])
    end

    def profile
      @user = current_user
      render :edit
    end

    def update
      @user = authorize community.users.find(params[:id])

      if @user.update(user_params.delete_if { |k, v| k == 'password' && v.blank? })
        if request.referrer.match?("profile") && @user.id == current_user.id
          redirect_to user_profile_path
        else
          redirect_to @user
        end
      else
        @user.password = nil
        render :edit
      end
    end

    def destroy
      @user = authorize community.users.find(params[:id])

      @user.destroy

      redirect_to users_path
    end

    def delete_photo
      @user = authorize community.users.find(params[:user_id])
      @user.photo.purge

      head :ok
    end

    private

    def user_params
      params.require(:user).permit(
        :name,
        :username,
        :email,
        :password,
        :role,
        :photo
      )
    end
  end
end