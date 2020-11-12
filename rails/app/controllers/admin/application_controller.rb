# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin

    before_action :set_locale

    def default_url_options
      { locale: I18n.locale }
    end

    helper_method :excluded_resources

    private

    def excluded_resources
      excluded = ['curriculum_stories']
      unless Flipper.enabled?(:curriculum)
        excluded << 'curriculums'
      end
      unless Flipper.enabled?(:media_links)
        excluded << 'media_links'
      end
      excluded
    end

    def set_locale
      excluded_resources
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def authenticate_admin
      redirect_to '/', alert: 'Not authorized.' unless current_user && current_user.editor?
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
