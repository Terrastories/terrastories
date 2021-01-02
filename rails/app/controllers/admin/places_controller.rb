module Admin
  class PlacesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Place.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Place.find_by!(slug: param)
    # end

    def new
      # ensures that place is built for the current community (so scopes in administrate dashboards work)
      resource = current_community.places.new
      authorize_resource(resource)
      render locals: {
        page: Administrate::Page::Form.new(dashboard, resource),
      }
    end

    def create
      resource = resource_class.new(resource_params)
      # ensures place is created within the current community
      resource.community = current_community
      authorize_resource(resource)

      if resource.save
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def import_csv
      if params[:file].nil?
        redirect_back(fallback_location: root_path)
        flash[:error] = "No file was attached!"
      else
        filepath = params[:file].read
        errors = Place.import_csv(filepath, current_community)
        errors.empty? ? flash[:notice] = "Places were imported successfully!" : flash[:error] = errors
        redirect_back(fallback_location: root_path)
      end
    end
  end
end
