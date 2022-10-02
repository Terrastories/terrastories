module ApplicationHelper
  def application_locales(request_path: nil)
    locales = I18n.available_locales.sort.map do |locale|
      locale_identifier = locale == I18n.locale ? "#{locale} (#{t("selected_language")}) " : locale
      link_to locale_identifier, link_to_with_locale(locale, request_path: request_path), class: "language-color"
    end
    safe_join(locales, " | ".html_safe)
  end

  def link_to_with_locale(locale, request_path: nil)
    if request_path.present?
      maybe_locale, path = request_path[1..-1].split("/", 2)
      if maybe_locale && I18n.available_locales.include?(maybe_locale.to_sym)
        "/#{locale}/#{path}"
      else
        "/#{locale}#{request_path}"
      end
    else
      root_path(locale: locale)
    end
  end
end
