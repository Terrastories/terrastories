require 'rails_helper'

RSpec.describe Story, type: :model do
  describe 'assocations' do
    it { should have_many :speaker_stories }
    it { should have_many :speakers }
    it { should have_and_belong_to_many :places }
    it { should belong_to(:interview_location).optional }
    it { should belong_to(:interviewer).optional }
  end

  describe 'validation' do
    let(:story_1) {build(:story)}
    let(:story_2) {create(:story, :with_speakers)}
    describe 'must have at least one speaker' do
      it {expect(story_1).to_not be_valid}
      it {expect(story_2).to be_valid}
    end
  end

  context '.import_csv' do
    describe 'is tested against fixture file' do
      it {expect(file_fixture('story_with_media.csv').read).not_to be_empty}
    end

    describe 'delegates all attributes to decorator' do
      before(:all) do
        @fixture_data = file_fixture('story_with_media.csv').read
        described_class.import_csv(@fixture_data)
      end
      let!(:story) {described_class.last}
      let!(:csv) {CSV.parse(@fixture_data, headers: true).first}


      it { expect(story.title).to eq csv[0] }
      it { expect(story.desc).to eq csv[1] }
      it { expect(story.speakers.map(&:name).join(',')).to eq csv[2] }
      it { expect(story.places.map(&:name).join(',')).to eq csv[3] }
      it { expect(story.interview_location.name).to eq csv[4] }
      it { expect(story.date_interviewed.strftime('%m/%d/%y')).to eq csv[5] }
      it { expect(story.interviewer.name).to eq csv[6].strip }
      it { expect(story.language).to eq csv[7] }
      it { expect(story.permission_level).to eq "anonymous" }
      it { expect(story.media.first.filename.to_s).to eq csv[8] }
    end

    describe 'does not fail when media is not present' do
      before do
        @fixture_data = file_fixture('story_without_media.csv').read
        described_class.import_csv(@fixture_data)

      end
      let!(:story) { described_class.last }
      let!(:csv) { CSV.parse(@fixture_data, headers: true).first }

      it {expect(story.media.all.count).to eq 0}
      it {expect(csv[8]).not_to be_nil}
    end

    describe 'displays error messages for failed imports' do
      before do
        @fixture_data = file_fixture('invalid stories.csv').read
      end
      it { expect(described_class.import_csv(@fixture_data)).not_to be_empty }
    end

    describe "does not fail when some rows in import are invalid" do
      it "creates valid speakers when importing a csv with invalid lines" do
        @fixture_data = file_fixture('invalid stories.csv').read
        expect {
          described_class.import_csv(@fixture_data)
        }.to change { Story.count }.by(1)
      end
    end

  end
end
