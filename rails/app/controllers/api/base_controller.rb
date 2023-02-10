module Api
  class BaseController < ActionController::Base
    respond_to :json

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    protected

    def not_found
      render json: {
        error: "Not Found",
        message: "The requested resource could not be found."
      }, status: :not_found
    end
  end
end
