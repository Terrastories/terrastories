module Dashboard
  class SpeakersController < ApplicationController
    def index
      @speakers = community.speakers
    end

    def show
      @speaker = community.speakers.find(params[:id])
    end
  end
end