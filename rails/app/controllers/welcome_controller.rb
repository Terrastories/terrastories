class WelcomeController < ApplicationController
  def index
    if current_community
      @theme = current_community.theme
    else
      redirect_to community_search_path
    end
  end
end
