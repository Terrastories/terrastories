require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many :stories }
    it { should have_many :interview_stories }
  end

  describe 'import_csv' do
    let(:community) { FactoryBot.create(:community) }

    it 'is tested against fixture file' do
      expect(file_fixture('place_with_media.csv').read).not_to be_empty
    end

    describe "does not create duplicated places" do
      it "creates a single place when importing the same csv twice" do
        @fixture_data = file_fixture('place_with_media.csv').read

        expect {
          described_class.import_csv(@fixture_data, community)
        }.to change { Place.count }.by(1)

        expect {
          described_class.import_csv(@fixture_data, community)
        }.to change { Place.count }.by(0)
      end
    end

    describe 'imports csv with media' do
      before do
        @fixture_data = file_fixture('place_with_media.csv').read
        described_class.import_csv(@fixture_data, community)
      end

      let!(:place) { described_class.last }
      let!(:csv) { CSV.parse(@fixture_data, headers: true).first }

      it { expect(place.name).to eq csv[0] }
      it { expect(place.type_of_place).to eq csv[1] }
      it { expect(place.description).to eq csv[2] }
      it { expect(place.region).to eq csv[3] }
      it { expect(place.long).to eq csv[4].to_f }
      it { expect(place.lat).to eq csv[5].to_f }
      it { expect(place.photo.filename.to_s).to eq csv[6] }
    end

    describe 'displays error messages for failed imports' do
      before do
        @fixture_data = file_fixture('invalid places.csv').read
      end
      it { expect(described_class.import_csv(@fixture_data, community)).not_to be_empty }
    end

    describe "does not fail when some rows in import are invalid" do
      it "creates valid places when importing a csv with invalid lines" do
        @fixture_data = file_fixture('invalid places.csv').read

        expect {
          described_class.import_csv(@fixture_data, community)
        }.to change { Place.count }.by(1)
      end
    end

    describe 'does not fail when media is not present' do
      before do
        @fixture_data = file_fixture('place_without_media.csv').read
        described_class.import_csv(@fixture_data, community)
      end

      let!(:place) { described_class.last }
      let!(:csv) { CSV.parse(@fixture_data, headers: true).first }
      it { expect(csv[6]).not_to be_nil }
    end

  end

  describe '#photo_format' do
    let(:community) { FactoryBot.create(:community) }

    context 'when the attachment is not located in an image folder' do
      describe 'should add an error' do
        before do
          @fixture_data = file_fixture('place_with_media.csv').read
          described_class.import_csv(@fixture_data, community)
          @place = described_class.last
          @place.photo.blob.content_type = "file/png"
          @place.photo_format
        end

        it { expect(@place.photo.blob.content_type.start_with?('image/')).to be(false) }
        it { expect(@place.errors.count).to eq(1) }
      end
    end

    context 'when the attachment is located in an image folder' do
      describe 'should not add an error' do
        before do
          @fixture_data = file_fixture('place_with_media.csv').read
          described_class.import_csv(@fixture_data, community)
        end
        let!(:place) { described_class.last }

        it { expect(place.photo.blob.content_type.start_with?('image/')).to be(true) }
        it { expect(place.errors.count).to eq(0) }
      end
    end
  end

  describe 'photo_url' do
    describe 'should return a url path' do
      let(:community) { FactoryBot.create(:community) }

      before do
        @fixture_data = file_fixture('place_with_media.csv').read
        described_class.import_csv(@fixture_data, community)
      end
      let!(:place) { described_class.last }
      let!(:file_name) { place.photo.filename.to_s }

      it { expect(place.photo_url).to be_truthy }
      it { expect(place.photo_url.include?(file_name)).to be(true) }
    end
  end

  describe 'point_geojson' do
    let(:community) { FactoryBot.create(:community) }

    it 'should return a geoJson point' do
      fixture_data = file_fixture('place_with_media.csv').read
      described_class.import_csv(fixture_data, community)
      place = described_class.first
      expect(place.point_geojson.keys).to include('properties')
    end
  end

  describe 'export_sample_csv' do
    it 'downloads a csv' do
      expect(described_class.export_sample_csv).to eq("name,description,region\n")
    end
  end
end
