module Admin
  class StoriesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Story.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Story.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
    def import_csv
      if params[:file].nil?
        redirect_back(fallback_location: root_path)
        flash[:error] = "No file was attached!"
      else
        filepath = params[:file].read
        errors = Story.import_csv(filepath)
        errors.empty? ? flash[:notice] = "Stories were imported successfully!" : flash[:error] = errors
        redirect_back(fallback_location: root_path)
      end
    end

    def export_sample_csv
      send_data Story.export_sample_csv, filename: "import-stories.csv"
    end
  end
end
