# Define default URL options for rails url helpers
#
Rails.application.routes.default_url_options[:host] = ENV.fetch("HOST_HOSTNAME", "localhost")
Rails.application.routes.default_url_options[:protocol] = Rails.env.production? ? "https" : "http"

# NOTE(LM): Heroku doesn't allow routing through port.
# So for now, disabling PORT if env is production.
unless Rails.env.production?
  Rails.application.routes.default_url_options[:port] = ENV.fetch("PORT", 3000)
end
