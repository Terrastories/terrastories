Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch("CORS_ORIGINS", "").split(",").map { |origin| origin[0] == "\\" ? Regexp.new(origin) : origin }
    resource '/api/*', headers: :any, methods: [:get]
  end
end
