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
    before_action :authenticate_admin

    before_action :set_locale

    def default_url_options
      { locale: I18n.locale }
    end

    private

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def authenticate_admin
      redirect_to '/', alert: 'Not authorized.' unless current_user.editor? || current_user.admin?
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
