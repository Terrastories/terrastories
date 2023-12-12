require "rails_helper"

RSpec.describe "Manage Stories", type: :request do
  let(:user) { FactoryBot.create(:user, community: community, role: :admin) }
  let(:unpinned_story) { FactoryBot.create(:story, :with_speakers, :with_places, story_pinned: false) }
  let(:pinned_story) { FactoryBot.create(:story, :with_speakers, :with_places, story_pinned: true) }
  let(:community) { FactoryBot.create(:community, stories: [unpinned_story, pinned_story]) }

  before do
    login_as user
  end

  describe "POST create" do
    context "user is admin or editor" do
      it "create a pinned story and unpin others" do
        post "/en/member/stories", params: { story: { story_pinned: true } }

        pinned_story.reload

        expect(community.stories.last.story_pinned).to eq(true)
        expect(pinned_story.story_pinned).to eq(false)
      end

      it "create an unpinned story" do
        post "/en/member/stories", params: { story: { story_pinned: false } }

        expect(community.stories.last.story_pinned).to eq(false)
        expect(pinned_story.story_pinned).to eq(true)
      end
    end
  end

  describe "PATCH update" do
    context "user is admin or editor" do
      it "pin an unpinned story and unpin others" do
        patch "/en/member/stories/#{unpinned_story.id}", params: { story: { story_pinned: true } }

        unpinned_story.reload
        pinned_story.reload

        expect(unpinned_story.story_pinned).to eq(true)
        expect(pinned_story.story_pinned).to eq(false)
      end

      it "unpin an pinned story" do
        patch "/en/member/stories/#{pinned_story.id}", params: { story: { story_pinned: false } }

        pinned_story.reload

        expect(pinned_story.story_pinned).to eq(false)
      end
    end
  end

  describe "PATCH pin" do
    context "user is admin or editor" do
      it "pin an unpinned story and unpin others" do
        patch "/en/member/stories/#{unpinned_story.id}/pin"

        unpinned_story.reload
        pinned_story.reload

        expect(unpinned_story.story_pinned).to eq(true)
        expect(pinned_story.story_pinned).to eq(false)
      end
    end
  end

  describe "PATCH unpin" do
    context "user is admin or editor" do
      it "unpin an pinned story" do
        patch "/en/member/stories/#{pinned_story.id}/unpin"

        pinned_story.reload

        expect(pinned_story.story_pinned).to eq(false)
      end
    end
  end
end
