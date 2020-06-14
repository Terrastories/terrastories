require 'rails_helper'

RSpec.describe Story, type: :model do
  describe 'assocations' do
    it { should have_many :speaker_stories }
    it { should have_many :speakers }
    it { should have_and_belong_to_many :places }

    # Issue 406 requested that interviewer and interview location be made optional for story creation
    it { should belong_to(:interview_location).optional }
    it { should belong_to(:interviewer).optional }
  end

  describe 'validation' do
    let(:story_1) {build(:story)}
    let(:story_2) {create(:story, :with_speakers)}
    it 'must have at least one speaker' do
      expect(story_1).to_not be_valid
      expect(story_2).to be_valid
    end
  end

  describe '.import_csv' do
    it 'is tested against fixture file' do
      expect(file_fixture('story_with_media.csv').read).not_to be_empty
    end

    it 'delegates all attributes to decorator' do
      fixture_data = file_fixture('story_with_media.csv').read
      described_class.import_csv(fixture_data)

      story = described_class.last
      csv = CSV.parse(fixture_data, headers: true).first

      expect(story.title).to eq csv[0]
      expect(story.desc).to eq csv[1]
      expect(story.speakers.map(&:name).join(',')).to eq csv[2]
      expect(story.places.map(&:name).join(',')).to eq csv[3]
      expect(story.interview_location.name).to eq csv[4]
      expect(story.date_interviewed.strftime('%m/%d/%y')).to eq csv[5]
      expect(story.interviewer.name).to eq csv[6].strip
      expect(story.language).to eq csv[7]
      expect(story.permission_level).to eq "anonymous"
      expect(story.media.first.filename.to_s).to eq csv[8]
    end

    it 'does not fail when media is not present' do
      fixture_data = file_fixture('story_without_media.csv').read
      described_class.import_csv(fixture_data)

      story = described_class.last
      csv = CSV.parse(fixture_data, headers: true).first

      expect(story.media.all.count).to eq 0
      expect(csv[8]).not_to be_nil
    end
  end
end
