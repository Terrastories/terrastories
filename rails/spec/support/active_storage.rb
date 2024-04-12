RSpec.configure do |config|
  config.after(:suite) do
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end
end