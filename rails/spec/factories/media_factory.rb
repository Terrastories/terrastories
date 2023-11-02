FactoryBot.define do
  factory :media do
    story
    media { Rack::Test::UploadedFile.new('spec/fixtures/media/terrastories.png', 'image/png') }
  end
end