class WelcomeController < ApplicationController
  def index
    if current_user.super_admin
      redirect_to super_admin_root_path
    elsif current_community
      @theme = current_community.theme
    else
      redirect_to community_search_path
    end
  end
end
