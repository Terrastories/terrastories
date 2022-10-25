require 'rails_helper'

RSpec.describe Community, type: :model do
  describe "associations" do
    let(:community) { FactoryBot.create(:community) }

    it "destroys associated places" do
      place = FactoryBot.create(:place, community: community)
      other_place = FactoryBot.create(:place)

      expect { community.destroy }.to change(Place, :count).by(-1)

      expect(Place.all.pluck(:id)).to eq([other_place.id])
    end

    it "destroys associated speakers" do
      speaker = FactoryBot.create(:speaker, community: community)
      other_speaker = FactoryBot.create(:speaker)

      expect { community.destroy }.to change(Speaker, :count).by(-1)

      expect(Speaker.all.pluck(:id)).to eq([other_speaker.id])
    end

    it "destroys associated stories" do
      speaker = FactoryBot.create(:speaker, community: community)
      place = FactoryBot.create(:place, community: community)
      story = FactoryBot.create(:story, community: community, speakers: [speaker], places: [place])
      other_story = FactoryBot.create(:story, :with_speakers)

      expect { community.destroy }.to change(Story, :count).by(-1)

      expect(Story.all.pluck(:id)).to eq([other_story.id])
      expect(Speaker.all.pluck(:id)).not_to include(speaker.id)
      expect(Place.all.pluck(:id)).not_to include(place.id)
    end
  end

  describe "associated_updated_at" do
    it "returns the latest updated at timestamp" do
      community = FactoryBot.create(:community, updated_at: 1.day.ago)
      speaker = FactoryBot.create(:speaker, community: community)
      place = FactoryBot.create(:place, community: community)
      story = FactoryBot.create(:story, community: community, speakers: [speaker], places: [place])

      expect(community.associated_updated_at).to eq(story.updated_at)

    end

    it "handles nil" do
      expect { community.associated_updated_at }.not_to raise_error
    end
  end
end
