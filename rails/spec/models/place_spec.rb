require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many :stories }
    it { should have_many :interview_stories }
  end

  let(:community) { create(:community) }
  let(:place) { described_class.new }

  describe "#csv_headers" do
    it "defines importable CSV headers" do
      expect(described_class.csv_headers).to eq(
        %i[
          name
          type_of_place
          lat
          long
          region
          description
          photo
          name_audio
        ]
      )
    end
  end

  describe "#import" do
    let(:mapped_headers) {{
      "name" => "name",
      "type_of_place" => "type_of_place",
      "description" => "description",
      "region" => "region",
      "long" => "long",
      "lat" => "lat"
    }.to_h}

    it "raises HeaderMismatchError when mapped headers are missing" do
      expect {
        described_class.import(
          file_fixture('place_without_media.csv'),
          community.id,
          mapped_headers.merge({"photo" => "other"})
        )
      }.to raise_error(Importable::FileImporter::HeaderMismatchError)
    end

    context "when CSV defines a column that is not mapped" do
      it "successfully imports places" do
        expect {
          described_class.import(file_fixture('place_with_excess_headers.csv'), community.id, mapped_headers)
        }.to change(described_class, :count).from(0).to(1)
      end
    end

    context "with media attachments" do
      before do
        stub_const("Importable::IMPORT_PATH", "spec/fixtures/media/")
      end
      context "when CSV defines photo file, but file is not found" do
        it "successfully imports places" do
          expect {
            described_class.import(
              file_fixture('place_with_missing_media.csv'),
              community.id,
              mapped_headers.merge({"photo" => "media"})
          )
          }.to change(described_class, :count).from(0).to(1)
        end
      end

      it "successfully imports places with photo" do
        described_class.import(
          file_fixture('place_with_media.csv'),
          community.id,
          mapped_headers.merge({"photo" =>  "media"})
        )
        expect(described_class.last.photo).to be_attached
      end

      it "successfully imports places with name audio" do
        described_class.import(
          file_fixture('place_with_media.csv'),
          community.id,
          mapped_headers.merge({"name_audio" =>  "audio"})
        )
        expect(described_class.last.name_audio).to be_attached
      end
    end

    context "when CSV has duplicate rows" do
      it "imports first row, returns rest as an array rows skipped" do
        import = described_class.import(file_fixture('duplicated_places.csv'), community.id, mapped_headers)
        expect(import[:successful]).to eq(1)
        expect(import[:skipped_rows].length).to eq(1)
      end
    end

    context "when Community already has a Place with the same name" do
      before do
        FactoryBot.create(:place, name: "Iacitata", community: community)
      end
      it "does not add duplicate row, returns in duplicate array" do
        import = described_class.import(file_fixture('place_without_media.csv'), community.id, mapped_headers)
        expect(import[:successful]).to eq(0)
        expect(import[:duplicated_rows].length).to eq(1)
      end
    end

    context "when row is invalid" do
      it "returns invalid rows with errors" do
        import = described_class.import(file_fixture('invalid places.csv'), community.id, mapped_headers)
        expect(import[:successful]).to eq(1)
        expect(import[:invalid_rows].length).to eq(2)
        expect(import[:invalid_rows].first.keys).to eq([:attributes, :errors])
      end
    end
  end

  describe 'export_sample_csv' do
    it 'downloads a csv' do
      expect(described_class.export_sample_csv).to eq("name,type_of_place,description,region,long,lat,media\n")
    end
  end
end
