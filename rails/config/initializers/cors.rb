Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:1080',/[a-z0-9]{4}-[0-9]{2}-[0-9]{3}-[0-9]{3}-[0-9]{3}.ngrok.io/
    resource '*', headers: :any, methods: [:get]
  end
end
