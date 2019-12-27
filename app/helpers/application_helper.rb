module ApplicationHelper
  def application_locales
    locales = I18n.available_locales.sort.map do |locale|
      locale_identifier = locale == :en ? "#{locale} (#{t("default")})" : locale
      link_to locale_identifier, root_path(locale: locale)
    end
    safe_join(locales, " | ".html_safe)
  end
end
