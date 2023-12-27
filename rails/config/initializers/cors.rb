Rails.application.config.middleware.insert_before 0, Rack::Cors do
  cors = ENV.fetch("CORS_ORIGINS", "").split(",")

  # This ensures that Explore can access TS locally when running with a custom hostname
  if ENV["HOST_HOSTNAME"]
    cors << ENV["HOST_HOSTNAME"]
    cors << ENV["HOST_HOSTNAME"] + ":1080"
  end

  allow do
    origins cors.map { |origin| origin[0] == "\\" ? Regexp.new(origin) : origin }
    resource '/api/*', headers: :any, methods: [:get]
    resource '/rails/active_storage/*', headers: :any, methods: [:get]
  end
end
