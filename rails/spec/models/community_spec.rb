require 'rails_helper'

RSpec.describe Community, type: :model do
  describe "associations" do
    let(:community) { FactoryBot.create(:community) }

    it "can add sponsor logo" do
      community.sponsor_logos.attach(io: File.open("./spec/fixtures/media/terrastories.png"), filename: 'file.pdf')
      expect(community).to be_valid
    end

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
      other_story = FactoryBot.create(:story, :with_speakers, :with_places, community: FactoryBot.create(:community))

      expect { community.destroy }.to change(Story, :count).by(-1)

      expect(Story.all.pluck(:id)).to eq([other_story.id])
      expect(Speaker.all.pluck(:id)).not_to include(speaker.id)
      expect(Place.all.pluck(:id)).not_to include(place.id)
    end
  end
end
