module Admin
  class CurriculumsController < Admin::ApplicationController
    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    # def update
    #   foo = Foo.find(params[:id])
    #   foo.update(params[:foo])
    #   send_foo_updated_email
    # end

    # def valid_action?(name, resource = resource_class)
      
    #   if name == :edit && resource == CurriculumStory
    #     # raise
    #     %w[edit destroy].exclude?(name.to_s) && super
    #   else 
    #     super
    #   end
    # end

    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    # def find_resource(param)
    #   Foo.find_by!(slug: param)
    # end

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    # def scoped_resource
    #  if current_user.super_admin?
    #    resource_class
    #  else
    #    resource_class.with_less_stuff
    #  end
    # end
    def new
      resource = new_resource      
      authorize_resource(resource) 
      resource.user_id = @current_user.id     
      render locals: { page: Administrate::Page::Form.new(dashboard, resource) }    
    end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
