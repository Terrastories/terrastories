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
    let(:story_1) {build(:story, :with_places)}
    let(:story_2) {build(:story, :with_speakers)}
    let(:story_3) {create(:story, :with_places, :with_speakers)}
    describe 'must have at least one speaker and a place' do
      it {expect(story_1).to_not be_valid}
      it {expect(story_2).to_not be_valid}
      it {expect(story_3).to be_valid}
    end
  end

  describe 'properties' do
    let(:story) {create(:story, :with_places, :with_speakers, language: "Portuguese")}
    describe 'stories have an optional language property'
    it {expect(story.language).to eq("Portuguese")}
  end

  describe 'export_sample_csv' do
    it 'downloads a csv' do
      expect(described_class.export_sample_csv).to eq("name,description,speakers,places,interview_location,date_interviewed,interviewer,language,media,permission_level\n")
    end
  end
end
