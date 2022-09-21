module Dashboard
  class CommunitiesController < ApplicationController
    before_action :authenticate_super_admin!

    def metrics_dashboard
      render locals: {
        places_count: Place.all.size,
        stories_count: Story.all.size,
        speakers_count: Speaker.all.size,
        communities_count: Community.all.size
      }
    end

    def index
      @page = CommunitiesPage.new(meta_params)
      @communities = @page.data

      respond_to do |format|
        format.html
        format.json {
          render json: {
            entries: render_to_string(partial: "communities", formats: [:html]),
            pagination: @page.has_next_page? ? communities_url(@page.next_page_meta) : nil
          }
        }
      end
    end

    def show
      @community = Community.find(params[:id])
    end

    def new
      @community = Community.new
    end

    def create
      @community = Community.new(community_params)

      if @community.save
        redirect_to @community
      else
        render :new
      end
    end

    def edit
      @community = Community.find(params[:id])
    end

    def update
      @community = Community.find(params[:id])

      if @community.update(community_params)
        redirect_to @community
      else
        render :edit
      end
    end

    def destroy
      @community = Community.find(params[:id])
      @community.destroy!

      redirect_to communities_url
    end

    private

    def authenticate_super_admin!
      raise Pundit::NotAuthorizedError unless current_user.super_admin
    end

    def community_params
      params.require(:community).permit(
        :name,
        :country,
        :locale,
        users_attributes: [
          :email,
          :password,
          :role
        ]
      )
    end
  end
end
