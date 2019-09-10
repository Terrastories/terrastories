# The home controller
class HomeController < ApplicationController
  def index
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
end
