module Admin
  class CommunitiesController < Admin::ApplicationController

    def show
      if current_user.super_admin && Community.find_by(id: params[:id]).nil?
        redirect_to admin_communities_path
      else
        super
      end
    end

    def find_resource(params)
      if current_user.super_admin
        Community.find_by(id: params)
      else
        current_community
      end
    end
  end
end
