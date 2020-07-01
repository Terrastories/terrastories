module ApplicationHelper
  def application_locales
    locales = I18n.available_locales.sort.map do |locale|
      locale_identifier = locale == I18n.locale ? "#{locale} (#{t("selected_language")}) " : locale
      link_to locale_identifier, root_path(locale: locale), class: "language-color"
    end
    safe_join(locales, " | ".html_safe)
  end
end
