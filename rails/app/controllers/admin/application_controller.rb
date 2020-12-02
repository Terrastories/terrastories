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

    def default_url_options
      { locale: I18n.locale }
    end

    private

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def set_community
      @_community ||= current_user.community
    end

    def current_community
      @_community
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
