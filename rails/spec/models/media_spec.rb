require "rails_helper"

RSpec.describe Media, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:story) }
  end

  describe "media validations" do
    it { is_expected.to validate_attached_of(:media) }

    it "validates image types" do
      is_expected.to validate_content_type_of(:media).allowing(
        'image/png',
        'image/jpg',
        'image/jpeg',
        'image/svg+xml',
      )
    end

    it "validates audio types" do
      is_expected.to validate_content_type_of(:media).allowing(
        'audio/mpeg',
        'audio/wav',
        'audio/mp4',
        'audio/m4a',
        'audio/x-m4a',
        'audio/x-aac',
        'audio/x-flac',
      )
    end

    it "validates video types" do
      is_expected.to validate_content_type_of(:media).allowing(
        'video/mpeg',
        'video/mp4',
        'video/quicktime',
        'video/webm',
      )
    end

    it "validates file size" do
      is_expected.to validate_size_of(:media).less_than_or_equal_to(200.megabytes)
    end
  end
end
