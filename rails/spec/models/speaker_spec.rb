require 'rails_helper'

RSpec.describe Speaker, type: :model do
  let(:community) { create(:community) }
  let(:speaker) { build(:speaker, name: speaker_name, birthdate: speaker_birthdate) }

  describe 'attributes' do
    let(:speaker_name) { 'Oliver Twist' }
    let(:speaker_birthdate) { DateTime.new(1992) }

    it 'has name and birthdate attributes' do
      expect(speaker).to have_attributes(name: speaker_name, birthdate: speaker_birthdate)
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:speaker_stories) }
    it { is_expected.to have_many(:stories).through(:speaker_stories) }
    it { is_expected.to belong_to(:birthplace).class_name('Place').optional }
  end

  describe '#picture_url' do
    let(:speaker_name) { 'Oliver Twist' }
    let(:speaker_birthdate) { DateTime.new(1992) }
    let(:photo_double) { double(:photo, attached?: attached?) }
    let(:router_double) { double(:router) }

    before do
      allow(speaker).to receive(:photo).and_return(photo_double)
      allow(Rails.application.routes).to receive_message_chain(:url_helpers, :rails_blob_path)
      allow(ActionController::Base.helpers).to receive(:image_path)

      subject
    end

    subject { speaker.picture_url }

    context 'when speaker has photo attached' do
      let(:attached?) { true }

      it 'call rails_blob_path with correct params' do
        expect(Rails.application.routes.url_helpers).to have_received(:rails_blob_path).with(photo_double, only_path: true)
      end
    end

    context "when speaker hasn't photo attached" do
      let(:attached?) { false }

      it 'call image_path with correct params' do
        expect(ActionController::Base.helpers).to have_received(:image_path).with('speaker.png', only_path: true)
      end
    end
  end

  describe "#csv_headers" do
    it "defines importable CSV headers" do
      expect(described_class.csv_headers).to eq(
        %i[
          name
          birthdate
          birthplace_id
          speaker_community
          photo
        ]
      )
    end
  end

  describe "#import" do
    let(:mapped_headers) {{
      "name" =>"name",
      "birthdate" =>"birthdate",
      "birthplace_id" =>"birthplace"
    }}

    it "raises HeaderMismatchError when mapped headers are missing" do
      expect {
        described_class.import(
          file_fixture('speaker_without_photo.csv'),
          community.id,
          mapped_headers.merge({media: "other"})
        )
      }.to raise_error(Importable::FileImporter::HeaderMismatchError)
    end

    context "when CSV defines a column that is not mapped" do
      it "successfully imports stories" do
        expect {
          described_class.import(file_fixture('speaker_with_photo.csv'), community.id, mapped_headers)
        }.to change(described_class, :count).from(0).to(1)
      end
    end

    context "with associations" do
      it "creates associated Birthplace (place)" do
        described_class.import(file_fixture('speaker_without_photo.csv'), community.id, mapped_headers)

        expect(community.places.find(described_class.last.birthplace_id)).to be
      end
    end

    context "with media attachments" do
      before do
        stub_const("Importable::IMPORT_PATH", "spec/fixtures/media/")
      end

      let(:mapped_headers) {{
        "name" => "name",
        "birthdate" => "birthdate",
        "birthplace_id" => "birthplace",
        "photo" => "photo"
      }}

      context "but media file is not found" do
        it "still successfully imports stories" do
          expect {
            described_class.import(
              file_fixture('speaker_with_missing_photo.csv'),
              community.id,
              mapped_headers
          )
          }.to change(described_class, :count).from(0).to(1)
        end
      end

      it "successfully imports stories with media" do
        expect {
          described_class.import(
            file_fixture('speaker_with_photo.csv'),
            community.id,
            mapped_headers
          )
        }.to change(described_class, :count).from(0).to(1)
        expect(described_class.last.photo).to be_attached
      end
    end

    context "when CSV has duplicate rows" do
      it "imports first row, returns rest as an array rows skipped" do
        import = described_class.import(file_fixture('duplicated_speakers.csv'), community.id, mapped_headers)
        expect(import[:successful]).to eq(1)
        expect(import[:skipped_rows].length).to eq(1)
      end
    end

    context "when Community already has a Story with the same name" do
      before do
        FactoryBot.create(:speaker, name: "Quirino", community: community)
      end
      it "does not add duplicate row, returns in duplicate array" do
        import = described_class.import(file_fixture('speaker_without_photo.csv'), community.id, mapped_headers)
        expect(import[:successful]).to eq(0)
        expect(import[:duplicated_rows].length).to eq(1)
      end
    end

    context "when row is invalid" do
      it "returns invalid rows with errors" do
        import = described_class.import(file_fixture('invalid speakers.csv'), community.id, mapped_headers)
        expect(import[:successful]).to eq(1)
        expect(import[:invalid_rows].length).to eq(1)
        expect(import[:invalid_rows].first.keys).to eq([:attributes, :errors])
      end
    end
  end

  describe 'export_sample_csv' do
    it 'downloads a csv' do
      expect(described_class.export_sample_csv).to eq("name,birthdate,birthplace,media\n")
    end
  end
end
