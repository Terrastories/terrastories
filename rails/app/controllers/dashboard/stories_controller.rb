module Dashboard
  class StoriesController < ApplicationController
    def index
      @stories = community.stories
      @stories = @stories.joins(:places).where(places: {id: params[:place]}) if params[:place].present?
      @stories = @stories.joins(:speakers).where(speakers: {id: params[:speaker]}) if params[:speaker].present?
      @stories = @stories.where(permission_level: params[:visibility]) if params[:visibility].present?
    end

    def show
      @story = community.stories.find(params[:id])
    end
  end
end