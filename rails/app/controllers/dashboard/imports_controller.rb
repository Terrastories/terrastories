module Dashboard
  class ImportsController < ApplicationController
    def show

    end

    def preview
      @model = params[:model]
      @required_headers = @model.classify.constantize&.csv_headers
      @csv = CSV.open(params[:file], headers: true) { |csv| csv.first.headers }

      render json: {
        headers: render_to_string(partial: "header_matches", formats: [:html])
      }
    end

    def create
      places_file = import_params[:places_csv]
      place_result = if places_file.present?
        place_headers = import_params[:place_headers].to_h
        Place.import(places_file, community.id, place_headers)
      end

      speakers_file = params[:speakers_csv]
      speaker_result = if speakers_file.present?
        speaker_headers = import_params[:speaker_headers].to_h
        Speaker.import(speakers_file, community.id, speaker_headers)
      end

      stories_file = params[:stories_csv]
      story_result = if stories_file.present?
        story_headers = import_params[:story_headers].to_h
        Story.import(stories_file, community.id, story_headers)
      end

      render locals: {
        places: place_result,
        speakers: speaker_result,
        stories: story_result
      }
    end

    private

    def import_params
      params.permit(
        :places_csv,
        :speakers_csv,
        :stories_csv,
        place_headers: Place.csv_headers,
        speaker_headers: Speaker.csv_headers,
        story_headers: Story.csv_headers
      )
    end
  end
end