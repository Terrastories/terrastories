class SpeakersController < ApplicationController
  def index
    @speakers = Speaker.all
  end

  def edit
    @speaker = Speaker.find_by(id: params[:id]) || Speaker.new
  end

  def new
    @speaker = Speaker.new
  end

  def show
    @speaker = Speaker.find_by(id: params[:id])
  end

  def create
    @speaker = Speaker.create(speaker_params)
    redirect_to speaker_path(@speaker)
  end

  def update
    @speaker = Speaker.find_by(id: params[:id])
    @speaker.update_attributes(speaker_params)
    redirect_to speaker_path(@speaker)
  end

  private

  def speaker_params
    params.require(:speaker).permit(:name, :media)
  end
end
