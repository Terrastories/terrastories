require 'rails_helper'

RSpec.describe "Home request", type: :request do
  describe "GET home" do
    context "a logged in user" do
      let(:user) { FactoryBot.create(:user) }
      before do
        login_as user
      end
      it "renders the home template" do
        get "/home"

        expect(response).to have_http_status(:success)
      end
    end
    context "an unauthenticated user" do
      it "forwards to the login page" do
        get "/home"

        expect(response).to redirect_to("/users/sign_in")
      end
    end

    context "orphaned stories" do
      let(:community) { FactoryBot.create(:community, name: "Orphaned Community") }
      let(:user) { FactoryBot.create(:user, community: community) }
      let!(:place_1) { create(:place, community: community, region: "test place 1") }
      let!(:place_2) { create(:place, community: community, region: "test place 2") }
      let!(:speaker_1) { create(:speaker, community: community) }
      let!(:speaker_2) { create(:speaker, community: community) }
      let!(:story_1) do
        create(
          :story,
          community: community,
          places: [place_1],
          speakers: [speaker_1],
          desc: "This story should not be visible because it has no speaker",
          permission_level: :anonymous
        )
      end
      let!(:story_2) do
        create(
          :story,
          community: community,
          places: [place_2],
          speakers: [speaker_2],
          desc: "This story should not be visible because it has no place",
          permission_level: :anonymous
        )
      end

      def json_response
        JSON.parse(response.body)
      end

      before do
        login_as user
      end

      it "excludes stories with no speaker and/or place" do
        speaker_1.destroy
        place_2.destroy
        get "/home"

        expect(response.body).not_to include('This story should not be visible because it has no speaker')
        expect(response.body).not_to include('This story should not be visible because it has no place')
      end
    end
  end
end
