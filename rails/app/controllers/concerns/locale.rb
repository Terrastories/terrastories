module Locale
  extend ActiveSupport::Concern

  included do
    before_action :set_locale

    def default_url_options
      { locale: params[:locale] || I18n.locale }
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
