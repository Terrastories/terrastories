class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, if: :offline_community?

  def index
    if offline_community?
      if Community.none?
        redirect_to start_onboarding_path
      end
    else
      if current_user&.super_admin
        redirect_to super_admin_root_path
      elsif current_community.nil?
        redirect_to community_search_path
      end
    end
  end
end
