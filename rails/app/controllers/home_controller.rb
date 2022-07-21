# The home controller
class HomeController < ApplicationController
  before_action :set_theme, except: :community_search_index

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

  private

  def set_theme
    @theme ||= current_community.theme
  end
end
