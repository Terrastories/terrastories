# Define default URL options for rails url helpers
#
Rails.application.routes.default_url_options[:host] = ENV.fetch("HOST_HOSTNAME", "localhost")

# NOTE(LM): Only set PORT in development
if Rails.env.development?
  Rails.application.routes.default_url_options[:port] = ENV.fetch("PORT", 3000)
end
