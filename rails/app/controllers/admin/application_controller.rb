# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include Administrate::Punditize

    before_action :authenticate_user!

    before_action :set_locale
    before_action :set_community
    before_action :can_view_list?, only: :index
    before_action :can_view_show?, only: :show

    rescue_from Pundit::NotAuthorizedError, with: :not_authorized

    def default_url_options
      { locale: I18n.locale }
    end

    private

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def not_authorized
      flash.alert = "You are not authorized to perform this action"
      redirect_to admin_root_path
    end

    def set_community
      @_community ||= current_user.community
    end

    helper_method def current_community
      @_community
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    # by default, Punditize with Administrate does not policy on index views.
    # this ensures we check that list views are utilizing the Pundit policies
    def can_view_list?
      authorize resource_name, :index?
    end

    # by default, Punditize with Administrate does not policy on show views.
    # this ensures we check that list views are utilizing the Pundit policies
    def can_view_show?
      authorize resource_name, :show?
    end
  end
end
