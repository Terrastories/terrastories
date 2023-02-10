module Api
  class CommunitiesController < BaseController
    def index
      @communities = Community.where(public: true).order(updated_at: :desc)
      @communities = @communities.where("name ilike :search", search: "%#{params[:search]}%") if params[:search]
    end

    def show
      @community = Community.where(public: true).find_by(slug: params[:id])

      unless @community
        render json: {
          error: "Community Not Found"
        }, status: :not_found
      end
    end
  end
end
