module Admin
  class SpeakersController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Speaker.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Speaker.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
    def import_csv
      if params[:file].nil?
        redirect_back(fallback_location: root_path)
        flash[:error] = "No file was attached!"
      else
        filepath = params[:file].read
        errors = Speaker.import_csv(filepath)
        errors.empty? ? flash[:notice] = "Speakers were imported successfully!" : flash[:error] = errors
        redirect_back(fallback_location: root_path)
      end
    end

    def default_sorting_attribute
      :name
    end

    def default_sorting_direction
      :asc
    end
  end
end
