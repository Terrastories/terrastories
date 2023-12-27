RSpec.configure do |config|
  config.before(:each) do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:fetch).and_call_original
  end
end