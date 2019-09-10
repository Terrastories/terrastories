module ApplicationHelper
  def non_default_locales
    non_default_locales = (I18n.available_locales - [I18n.default_locale]).map do |locale|
      link_to locale, root_path(locale: locale)
    end
    safe_join(non_default_locales, " | ".html_safe)
  end
end
