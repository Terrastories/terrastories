# The home controller
class HomeController < ApplicationController
  def index
    if current_user.super_admin
      raise Pundit::NotAuthorizedError
    end
  end

  def community_search_index
    # This will eventually be a searchable action for the public maps and stories of
    # communities within this app. For now, it's just a placeholder.
  end

  def show
    render layout: false
    # either show an existing point, or show a form to create a new one
  end

  def create
    # save the story to the database
  end

  helper_method def stories
    policy_scope(Story)
  end

  helper_method def mapbox_token
    current_community.theme.mapbox_access_token.presence || ENV["MAPBOX_ACCESS_TOKEN"]
  end

  helper_method def local_mapbox?
    ENV["USE_LOCAL_MAP_SERVER"].present?
  end

  helper_method def mapbox_style
    if local_mapbox?
      "http://localhost:8080/styles/basic/style.json"
    else
      current_community.theme.mapbox_style_url.presence || ENV["MAPBOX_STYLE"]
    end
  end

  helper_method def center_lat
    current_community.theme.center_lat.present? ? current_community.theme.center_lat : 38.5
  end

  helper_method def center_long
    current_community.theme.center_long.present? ? current_community.theme.center_long : -108
  end
end
