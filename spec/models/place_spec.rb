require 'rails_helper'
require 'csv'


RSpec.describe Place, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many :stories }
    it { should have_many :interview_stories }
  end

  describe 'import_csv' do
     it 'is tested against fixture file' do
      expect(file_fixture('place_with_media.csv').read).not_to be_empty
    end

    it 'imports csv' do
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
    end

    it 'attaches photo' do

    end

  end

  describe '#photo_format' do
    it 'should have a prefix' do
    end
  end

  describe 'photo_url' do
  end

  describe 'point_geojson' do
  end

  pending "add some examples to (or delete) #{__FILE__}"
end
