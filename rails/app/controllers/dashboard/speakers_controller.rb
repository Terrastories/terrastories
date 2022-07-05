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

    def show
      @speaker = community.speakers.find(params[:id])
    end
  end
end