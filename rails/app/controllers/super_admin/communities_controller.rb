module SuperAdmin
  class CommunitiesController < ApplicationController
    def index
      @page = CommunitiesPage.new(filter_params)
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

    def filter_params
      params.permit(
        :limit,
        :offset,
        :name,
        :sort_by,
        :sort_dir
      )
    end

    def community_params
      params.require(:community).permit(
        :name,
        :country,
        :locale,
        users_attributes: [
          :username,
          :email,
          :password,
          :role
        ]
      )
    end
  end
end
