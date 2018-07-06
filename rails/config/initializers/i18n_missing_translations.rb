i18n_simple_backend = I18n::Backend::Simple.new
old_handler = I18n.exception_handler
I18n.exception_handler = lambda do |exception, locale, key, options|
  case exception
  when I18n::MissingTranslation
    i18n_simple_backend.translate(:srm, key, options || {})
  else
    old_handler.call(exception, locale, key, options)
  end
end
