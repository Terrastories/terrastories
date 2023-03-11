# Define default URL options for rails url helpers
#
Rails.application.routes.default_url_options[:host] = ENV.fetch("HOST_HOSTNAME", "localhost")
Rails.application.routes.default_url_options[:port] = ENV.fetch("PORT", 3000)
