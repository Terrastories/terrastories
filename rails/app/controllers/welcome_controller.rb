class WelcomeController < ApplicationController
  def index
    if current_community
      @theme = current_community.theme
    elsif current_user.super_admin
      redirect_to admin_communities_path
    else
      redirect_to community_search_path
    end
  end
end
