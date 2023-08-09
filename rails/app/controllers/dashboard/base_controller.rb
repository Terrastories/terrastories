module Dashboard
  class BaseController < ApplicationController
    rescue_from Pundit::NotAuthorizedError, with: :not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    layout "dashboard"

    before_action :authenticate_user!

    protected

    def not_authorized
      flash.alert = "You are not authorized to perform this action"
      redirect_to member_root_path
    end

    def not_found
      flash.alert = "The resource you requested cannot be found"
      redirect_to member_root_path
    end

    private

    def meta_params
      params.permit(
        :limit,
        :offset
      )
    end
  end
end
