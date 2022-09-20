module Dashboard
  class SpeakersController < ApplicationController
    def index
      @page = SpeakersPage.new(community, params)
      @speakers = @page.data

      respond_to do |format|
        format.html
        format.json {
          render json: {
            entries: render_to_string(partial: "speakers", formats: [:html]),
            pagination: @page.has_next_page? ? speakers_url(@page.next_page_meta) : nil
          }
        }
      end
    end

    def new
      authorize @speaker = community.speakers.new
    end

    def create
      authorize Speaker
      @speaker = community.speakers.new(speaker_params)

      if @speaker.save
        redirect_to @speaker
      else
        render :new
      end
    end

    def show
      @speaker = community.speakers.find(params[:id])
    end

    def edit
      @speaker = authorize community.speakers.find(params[:id])
    end

    def update
      @speaker = authorize community.speakers.find(params[:id])

      if @speaker.update(speaker_params)
        redirect_to @speaker
      else
        render :edit
      end
    end

    def destroy
      @speaker = authorize community.speakers.find(params[:id])

      @speaker.destroy

      redirect_to speakers_path
    end

    def delete_photo
      @speaker = authorize community.speakers.find(params[:speaker_id])
      @speaker.photo.purge

      head :ok
    end

    private

    def speaker_params
      params.require(:speaker).permit(
        :name,
        :photo,
        :speaker_community,
        :birthdate,
        :birthplace,
        story_ids: []
      )
    end
  end
end