class StoriesController < ApplicationController
  def index
    @stories = Story.all
    respond_to do |format|
      format.json
    end
  end

  def edit
    @story = Story.find_by(id: params[:id]) || Story.new
  end

  def new
    @story = Story.new
  end

  def show
    @story = Story.find_by(id: params[:id])
  end

  def create
    @story = Story.create(story_params)
    redirect_to story_path(@story)
  end

  def update
    @story = Story.find_by(id: params[:id])
    @story.update_attributes(story_params)
    redirect_to story_path(@story)
  end

  def delete
    remove_attachment
  end

  def import_csv
    if params[:file].nil?
      redirect_back(fallback_location: root_path)
      flash[:error] = "No file was attached!"
    else
      filepath = params[:file].path
      Story.import_csv(filepath)
      flash[:notice] = "Stories were imported successfully!"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def story_params
    params.require(:story).permit(:title, :desc, :speaker_id, :point_id, media: [])
  end

  def remove_attachment
    media = ActiveStorage::Attachment.find(params[:attachment_id])
    media.purge
    redirect_back(fallback_location: "/")
  end
end
