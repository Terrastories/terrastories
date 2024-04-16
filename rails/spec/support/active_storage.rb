RSpec.configure do |config|
  config.after(:suite) do
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end
end

def blob_url(blob, host = "www.example.com")
  Rails.application.routes.url_helpers.rails_blob_url(blob, host: host)
end
