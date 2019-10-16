require 'rails_helper'

RSpec.describe StoryMediaDecorator do
  describe '#attachable?' do
    it 'returns true when file exists at media path' do
      expect(described_class.new("#{SecureRandom.hex(4)}.png")).not_to be_attachable
      expect(described_class.new("terrastories.png")).to be_attachable
    end
  end

  describe '#blob_data' do
    it 'returns blob details when media is attachable' do
      blob_data = described_class.new("terrastories.png").blob_data
      expect(blob_data[:io]).to be_present
      expect(blob_data[:filename]).to eq "terrastories.png"
    end
  end
end
