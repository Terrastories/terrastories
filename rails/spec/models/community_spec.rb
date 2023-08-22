require 'rails_helper'

RSpec.describe Community, type: :model do
  let(:community) { FactoryBot.create(:community) }

  describe "associations" do
    it "can add sponsor logo" do
      community.sponsor_logos.attach(io: File.open("./spec/fixtures/media/terrastories.png"), filename: 'file.pdf')
      expect(community).to be_valid
    end

    it "requires a slug when community is marked as public" do
      community.slug = nil
      community.public = true
      expect(community).not_to be_valid
      expect(community.errors).to include(:slug)

      community.slug = "imaslug"
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

  describe "slug=(value)" do
    it "uses Community name even if public is disabled" do
      community = Community.new(name: "New Community", public: false, slug: nil)
      expect(community.slug).to eq("new_community")
    end

    it "uses Community name when value is blank and public is enabled" do
      community = Community.new(name: "New Community", public: true, slug: "")
      expect(community.slug).to eq("new_community")
    end

    it "sets slug as value" do
      community = Community.new(name: "New Community", slug: "custom_slug")
      expect(community.slug).to eq("custom_slug")
    end

    it "appends incremental number when slug already exists" do
      FactoryBot.create(:community, slug: "custom_slug")
      community = Community.new(name: "New Community", slug: "custom_slug")
      expect(community.slug).to eq("custom_slug_1")
    end

    it "replaces incremental number when needed (avoids slug_1_1 problems)" do
      community = FactoryBot.create(:community, slug: "custom_slug_1")
      attrs = {name: "New Community", slug: "custom_slug_1"}
      community.assign_attributes(attrs)
      expect(community.slug).to eq("custom_slug_1")
    end
  end

  context ".filters" do
    let(:public_speaker) { FactoryBot.create(:speaker, name: "Public Speaker", speaker_community: "AI Friends", community: community) }
    let(:public_place) { FactoryBot.create(:place, name: "Public Place", region: "Around", type_of_place: "test", community: community) }
    let!(:public_story) do
      FactoryBot.create(
        :story,
        community: community,
        speakers: [public_speaker],
        places: [public_place],
        topic: "Testing Public",
        language: "Ruby",
        permission_level: :anonymous
      )
    end

    let(:private_speaker) { FactoryBot.create(:speaker, name: "Robot", speaker_community: "AI Friends", community: community) }
    let(:private_place) { FactoryBot.create(:place, community: community) }
    let!(:private_story) { FactoryBot.create(:story, community: community, speakers: [private_speaker], places: [private_place], permission_level: :user_only) }

    it "returns available options for filters for a community's public stories" do
      expect(community.filters).to contain_exactly(
        {label: "Public Place", value: public_place.id, category: :places},
        {label: "Testing Public", value: "Testing Public", category: :topic},
        {label: "Around", value: "Around", category: :region},
        {label: "test", value: "test", category: :type_of_place},
        {label: "Ruby", value: "Ruby", category: :language},
        {label: "Public Speaker", value: public_speaker.id, category: :speakers},
        {label: "AI Friends", value: "AI Friends", category: :speaker_community},
      )

      # private speaker becomes a public speaker when added to a public story
      public_story.speakers << private_speaker
      public_story.save

      expect(community.filters).to contain_exactly(
        {label: "Public Place", value: public_place.id, category: :places},
        {label: "Testing Public", value: "Testing Public", category: :topic},
        {label: "Around", value: "Around", category: :region},
        {label: "test", value: "test", category: :type_of_place},
        {label: "Ruby", value: "Ruby", category: :language},
        {label: "Public Speaker", value: public_speaker.id, category: :speakers},
        # Duplicated values should be unique
        {label: "AI Friends", value: "AI Friends", category: :speaker_community},
        # newly added speaker
        {label: "Robot", value: private_speaker.id, category: :speakers},
      )
    end

    it "can return all filters based on permission level passed" do
      expect(community.filters([:anonymous, :user_only])).to contain_exactly(
        {label: "Public Place", value: public_place.id, category: :places},
        {label: private_place.name, value: private_place.id, category: :places},
        {label: "Testing Public", value: "Testing Public", category: :topic},
        {label: "Around", value: "Around", category: :region},
        {label: private_place.region, value: private_place.region, category: :region},
        {label: "test", value: "test", category: :type_of_place},
        {label: private_place.type_of_place, value: private_place.type_of_place, category: :type_of_place},
        {label: "Ruby", value: "Ruby", category: :language},
        {label: "English", value: "English", category: :language},
        {label: "Public Speaker", value: public_speaker.id, category: :speakers},
        {label: "Robot", value: private_speaker.id, category: :speakers},
        {label: "AI Friends", value: "AI Friends", category: :speaker_community},
      )
    end
  end
end
