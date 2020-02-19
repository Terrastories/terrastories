require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many :stories }
    it { should have_many :interview_stories }
  end

  describe 'import_csv' do
    it 'is tested against fixture file' do
      expect(file_fixture('place_with_media.csv').read).not_to be_empty
    end

    it 'imports csv with media' do
      fixture_data = file_fixture('place_with_media.csv').read
      described_class.import_csv(fixture_data)

      place = described_class.first
      csv = CSV.parse(fixture_data, headers: true).first

      expect(place.name).to eq csv[0]
      expect(place.type_of_place).to eq csv[1]
      expect(place.description).to eq csv[2]
      expect(place.region).to eq csv[3]
      expect(place.long).to eq csv[4].to_f
      expect(place.lat).to eq csv[5].to_f
      expect(place.photo.filename.to_s).to eq csv[6]
    end

    it 'does not fail when media is not present' do
      fixture_data = file_fixture('place_without_media.csv').read
      described_class.import_csv(fixture_data)

      place = described_class.first
      csv = CSV.parse(fixture_data, headers: true).first
      expect(csv[6]).not_to be_nil
    end
  end

  describe '#photo_format' do
    context 'when the attachment is not located in an image folder' do
      it 'should add an error' do
        fixture_data = file_fixture('place_with_media.csv').read
        described_class.import_csv(fixture_data)
        place = described_class.first
        place.photo.blob.content_type = "file/png"
        place.photo_format

        expect(place.photo.blob.content_type.start_with?('image/')).to be(false)
        expect(place.errors.count).to eq(1)
      end
    end

    context 'when the attachment is located in an image folder' do
      it 'should not add an error' do
        fixture_data = file_fixture('place_with_media.csv').read
        described_class.import_csv(fixture_data)
        place = described_class.first
        place.photo_format

        expect(place.photo.blob.content_type.start_with?('image/')).to be(true)
        expect(place.errors.count).to eq(0)
      end
    end
  end

  describe 'photo_url' do
    it 'should return a url path' do
      fixture_data = file_fixture('place_with_media.csv').read
      described_class.import_csv(fixture_data)
      place = described_class.first
      file_name = place.photo.filename.to_s

      expect(place.photo_url).to be_truthy
      expect(place.photo_url.include?(file_name)).to be(true)
    end
  end

  describe 'point_geojson' do
    it 'should return a geoJson point' do
      fixture_data = file_fixture('place_with_media.csv').read
      described_class.import_csv(fixture_data)
      place = described_class.first
      expect(place.point_geojson.keys).to include('properties')
    end
  end
end
