require "rails_helper"

RSpec.describe "Manage Community", type: :request do

  describe "PATCH update community" do
    context "community is public" do
      let(:community) { FactoryBot.create(:community, public: false) }
      let(:user) { FactoryBot.create(:user, community: community, role: :admin) }

      before do
        login_as user
      end

      before do
        # Enable Feature
        allow(Flipper).to receive(:enabled?).with(anything, community) { false }
        allow(Flipper).to receive(:enabled?).with(:public_communities, community) { true }
      end

      it "generates a static map when public is enabled" do
        allow(URI).to receive(:open) { File.open("./spec/fixtures/media/terrastories.png") }

        patch "/en/member/community", params: {community: {public: true}}

        expect(response).to redirect_to(community_settings_path)
        expect(community.theme.static_map.attached?).to be true
      end

      it "skips generation if no access token is present (either self-added or not set in server eng)" do
        # set default to nil (set in initializers/tileserver.rb)
        expect(Rails.application.config).to receive(:default_mapbox_token)

        patch "/en/member/community", params: {community: {public: true}}

        expect(community.theme.static_map.attached?).to be false
      end

      it "continues even if the generated static map cannot be attached to community" do
        expect(URI).to receive(:open).and_raise(OpenURI::HTTPError.new("401 Unauthorized", {}))

        patch "/en/member/community", params: {community: {public: true}}

        expect(community.theme.static_map.attached?).to be false
      end
    end
  end
end