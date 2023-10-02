require 'rails_helper'

RSpec.describe Story, type: :model do
  let(:community) { create(:community) }

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

  describe "#csv_headers" do
    it "defines importable CSV headers" do
      expect(described_class.csv_headers).to match_array(
        %i[
          title
          desc
          permission_level
          date_interviewed
          language
          interview_location_id
          interviewer_id
          topic
          speakers
          places
          media
        ]
      )
    end
  end

  describe "#import" do
    let(:mapped_headers) {{
      "title" => "name",
      "desc" => "description",
      "places" => "places",
      "speakers" => "speakers",
      "interview_location_id" => "interview_location",
      "date_interviewed" => "date_interviewed",
      "interviewer_id" => "interviewer",
      "language" => "language"
    }}

    it "raises HeaderMismatchError when mapped headers are missing" do
      expect {
        described_class.import(
          file_fixture('story_without_media.csv'),
          community.id,
          mapped_headers.merge({media: "other"})
        )
      }.to raise_error(Importable::FileImporter::HeaderMismatchError)
    end

    context "when CSV defines a column that is not mapped" do
      it "successfully imports stories" do
        expect {
          described_class.import(file_fixture('story_with_media.csv'), community.id, mapped_headers)
        }.to change(described_class, :count).from(0).to(1)
      end
    end

    context "with associations" do
      it "creates associated Place records" do
        expect {
          described_class.import(file_fixture('story_without_media.csv'), community.id, mapped_headers)
        }.to change(Place, :count).by(2)
      end

      it "creates associated Speaker records" do
        expect {
          described_class.import(file_fixture('story_without_media.csv'), community.id, mapped_headers)
        }.to change(Speaker, :count).by(2)
      end

      it "creates associated Interviewer (speaker)" do
        described_class.import(file_fixture('story_without_media.csv'), community.id, mapped_headers)

        expect(community.speakers.find(described_class.last.interviewer_id)).to be
      end

      it "creates associated Interview Location (place)" do
        described_class.import(file_fixture('story_without_media.csv'), community.id, mapped_headers)

        expect(community.places.find(described_class.last.interview_location_id)).to be
      end
    end

    context "when has_many associations have trailing whitespaces" do
      it "strips trailing whitespaces from Speaker_name and Place_name" do
        described_class.import(file_fixture('story_with_trailing_whitespaces.csv'), community.id, mapped_headers)
        story = described_class.last
  
        expect(story.speakers.map(&:name)).to all(satisfy { |name| name == name.strip })
        expect(story.places.map(&:name)).to all(satisfy { |name| name == name.strip })
      end
    end

    context "with media attachments" do
      before do
        stub_const("Importable::IMPORT_PATH", "spec/fixtures/media/")
      end

      let(:mapped_headers) {{
        "title" => "name",
        "desc" => "description",
        "places" => "places",
        "speakers" => "speakers",
        "interview_location_id" => "interview_location",
        "date_interviewed" => "date_interviewed",
        "interviewer_id" => "interviewer",
        "language" => "language",
        "media" => "media"
      }}

      context "but media file is not found" do
        it "still successfully imports stories" do
          expect {
            described_class.import(
              file_fixture('story_with_missing_media.csv'),
              community.id,
              mapped_headers
          )
          }.to change(described_class, :count).from(0).to(1)
        end
      end

      it "successfully imports stories with media" do
        expect {
          described_class.import(
            file_fixture('story_with_media.csv'),
            community.id,
            mapped_headers
          )
        }.to change(described_class, :count).from(0).to(1)
        expect(described_class.last.media.size).to eq(1)
      end

      it "successfully imports stories with multiple medias" do
        expect {
          described_class.import(
            file_fixture('story_with_multiple_media.csv'),
            community.id,
            mapped_headers
          )
        }.to change(described_class, :count).from(0).to(1)
        expect(described_class.last.media.size).to eq(2)
      end
    end

    context "when permission level is included in CSV" do
      let(:mapped_headers) {{
        "title" => "name",
        "desc" => "description",
        "places" => "places",
        "speakers" => "speakers",
        "interview_location_id" => "interview_location",
        "date_interviewed" => "date_interviewed",
        "interviewer_id" => "interviewer",
        "language" => "language",
        "permission_level" => "permission_level"
      }}

      it "sets permission level to nil when row is blank" do
        described_class.import(
          file_fixture('story_without_media.csv'),
          community.id,
          mapped_headers
        )
        # Note: `nil` is more or less equivalent to admin / editor only
        expect(described_class.last.permission_level).to eq("anonymous")
      end

      it "sets permission level to user_only when row has data included" do
        described_class.import(
          file_fixture('story_with_permission_levels.csv'),
          community.id,
          mapped_headers
        )
        expect(described_class.last.permission_level).to eq("user_only")
      end

      it "correctly updates even when mapped header is different" do
        described_class.import(
          file_fixture('story_with_permission_levels.csv'),
          community.id,
          mapped_headers.merge({permission_level: "permissions"})
        )
        expect(described_class.last.permission_level).to eq("user_only")
      end
    end

    context "when CSV has duplicate rows" do
      it "imports first row, returns rest as an array rows skipped" do
        import = described_class.import(file_fixture('duplicated_stories.csv'), community.id, mapped_headers)
        expect(import[:successful]).to eq(1)
        expect(import[:skipped_rows].length).to eq(1)
      end
    end

    context "when Community already has a Story with the same name" do
      before do
        FactoryBot.create(:story, :with_speakers, :with_places, title: "What is TerraStories", community: community)
      end
      it "does not add duplicate row, returns in duplicate array" do
        import = described_class.import(file_fixture('story_without_media.csv'), community.id, mapped_headers)
        expect(import[:successful]).to eq(0)
        expect(import[:duplicated_rows].length).to eq(1)
      end
    end

    context "when row is invalid" do
      it "returns invalid rows with errors" do
        import = described_class.import(file_fixture('invalid stories.csv'), community.id, mapped_headers)
        expect(import[:successful]).to eq(1)
        expect(import[:invalid_rows].length).to eq(1)
        expect(import[:invalid_rows].first.keys).to eq([:attributes, :errors])
      end
    end
  end

  describe 'export_sample_csv' do
    it 'downloads a csv' do
      expect(described_class.export_sample_csv).to eq("name,description,speakers,places,interview_location,date_interviewed,interviewer,language,media,permission_level\n")
    end
  end
end
