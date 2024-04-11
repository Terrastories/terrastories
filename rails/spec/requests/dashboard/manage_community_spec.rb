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

      context "when Mapbox is configured" do
        before { allow(Map).to receive(:mapbox_access_token).and_return("pk.eyTest") }

        it "generates a static map when public is enabled & Mapbox is configured" do
          allow(URI).to receive(:open) { File.open("./spec/fixtures/media/terrastories.png") }

          patch "/en/member/community", params: {community: {public: true}}

          expect(response).to redirect_to(community_settings_path)
          expect(community.theme.static_map.attached?).to be true
        end

        it "continues even if the generated static map cannot be attached to community" do
          expect(URI).to receive(:open).and_raise(OpenURI::HTTPError.new("401 Unauthorized", {}))

          patch "/en/member/community", params: {community: {public: true}}

          expect(community.theme.static_map.attached?).to be false
        end
      end

      it "skips generation if no access token is present (either self-added or not set in server eng)" do
        patch "/en/member/community", params: {community: {public: true}}

        expect(community.theme.static_map.attached?).to be false
      end
    end
  end

  # Spec for testing removal of config.active_storage.replace_on_assign_to_many = false
  # default is true; so we want to make sure we don't screw this up.
  describe "Sponsor Logos Assigns Appends" do
    let(:community) { FactoryBot.create(:community) }
    let(:user) { FactoryBot.create(:user, community: community, role: :admin) }

    before do
      login_as user
      allow(Flipper).to receive(:enabled?).with(:split_settings, community) { true }
      community.sponsor_logos.attach(io: file_fixture("media/terrastories.png").open, filename: "sponsor.png", content_type: "image/png")
    end

    it "new sponsor logo is added to community record" do
      expect {
        patch "/en/member/community", params: {community: {sponsor_logos: [fixture_file_upload("media/speaker.png")]}}
        expect(response).to have_http_status(:redirect)
      }.to change(community.sponsor_logos, :count).by(1)
    end
  end
end
