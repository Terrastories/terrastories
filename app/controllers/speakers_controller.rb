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

  def import_csv
    if params[:file].nil?
      redirect_back(fallback_location: root_path)
      flash[:error] = "No file was attached!"
    else
      filepath = params[:file].read
      Speaker.import_csv(filepath)
      flash[:notice] = "Speakers were imported successfully!"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def speaker_params
    params.require(:speaker).permit(:name, :media, :community)
  end
end
