require 'rails_helper'

RSpec.describe Speaker, type: :model do
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

  context '.import_csv' do
    let(:community) { FactoryBot.create(:community) }

    describe 'is tested against fixture file' do
      it { expect(file_fixture('speaker_with_photo.csv').read).not_to be_empty }
    end

    describe 'delegates all attributes to decorator' do
      let(:speaker) { described_class.last }
      let(:csv) { CSV.parse(@fixture_data, headers: true).first }

      before do
        @fixture_data = file_fixture('speaker_with_photo.csv').read
        described_class.import_csv(@fixture_data, community)
      end

      it { expect(speaker.name).to eq csv[0] }
      it { expect(speaker.birthdate).to eq Date.strptime(csv[1], '%Y') }
      it { expect(speaker.birthplace).to eq described_class.get_birthplace(csv[2], community) }
      it { expect(speaker.photo.filename.to_s).to eq csv[3] }
    end

    describe 'does not fail when photo is not present' do
      let(:speaker) { described_class.last }
      let(:csv) { CSV.parse(@fixture_data, headers: true).first }

      before do
        @fixture_data = file_fixture('speaker_without_photo.csv').read
        described_class.import_csv(@fixture_data, community)
      end

      it { expect(speaker.photo.attached?).to be_falsey }
      it { expect(csv[3]).not_to be_nil }
    end

    describe 'displays error messages for failed imports' do

    end
    
    describe "displays error messages for failed imports" do
      before do
        @fixture_data = file_fixture('invalid speakers.csv').read
      end
      it "is implemented but waiting on" do
        pending("validations on speaker model")
        expect(described_class.import_csv(@fixture_data)).not_to be_empty
      end
    end

    describe "does not fail when some rows in import are invalid" do
      it "creates valid speakers when importing a csv with invalid lines" do
        @fixture_data = file_fixture('invalid speakers.csv').read
        pending("validations on speaker model")
        expect {
          described_class.import_csv(@fixture_data)
        }.to change { Speaker.count }.by(1)
      end
    end

  end

  describe '.get_birthplace' do
    let(:community) { FactoryBot.create(:community) }
    let!(:birthplace) { create(:place, name: 'Anapolis', community: community) }

    subject { described_class.get_birthplace(birthplace_name, community) }

    context 'when found birthplace_name' do
      let(:birthplace_name) { 'Anapolis' }

      it { is_expected.to eql birthplace }
    end

    context 'when birthplace_name is nil' do
      let(:birthplace_name) { nil }

      it { is_expected.to be_nil }
    end

    context 'when birthplace_name is unknown' do
      let(:birthplace_name) { 'unknown' }

      it { is_expected.to be_nil }
    end
  end
end
