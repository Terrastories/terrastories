require "rails_helper"

RSpec.describe "Public Story Detail Endpoint", type: :request do
  let!(:community) { FactoryBot.create(:public_community, name: "Cool Community") }
  let!(:place_1) { create(:place, community: community, region: "the internet") }
  let!(:place_2) { create(:place, community: community, type_of_place: "online") }
  let!(:speaker_1) { create(:speaker, community: community) }
  let!(:speaker_2) { create(:speaker, community: community, speaker_community: "ruby for good") }

  let!(:story) do
    create(
      :story,
      id: 123,
      community: community,
      topic: "Testing",
      language: "English",
      places: [place_1, place_2],
      speakers: [speaker_1, speaker_2],
      permission_level: :anonymous
    )
  end

  it "returns 404 when community can't be found" do
    get "/api/communities/unknown/stories/123"

    expect(response).to have_http_status(:not_found)
  end

  it "returns a 404 when community is not public" do
    private_community = FactoryBot.create(:community, slug: "something")

    get "/api/communities/#{private_community.slug}/stories/123"

    expect(response).to have_http_status(:not_found)
  end

  it "returns a 404 when story is not found" do
    get "/api/communities/cool_community/stories/unknown"

    expect(response).to have_http_status(:not_found)
  end

  it "returns a 404 when story is not public / anonymous" do
    private_story = create(:story, :with_places, :with_speakers, permission_level: :user_only)

    get "/api/communities/cool_community/stories/#{private_story.id}"

    expect(response).to have_http_status(:not_found)
  end

  it "returns story details" do
    get "/api/communities/cool_community/stories/123"

    expect(response).to have_http_status(:ok)
    expect(json_response.keys).to contain_exactly(
      "id",
      "title",
      "desc",
      "topic",
      "language",
      "media",
      "speakers",
      "places",
      "points"
    )
  end

  it "returns optional story details when they are available" do
    interviewer = create(:speaker, community: community)
    interview_location = create(:place, community: community)
    story.update!(
      interviewer: interviewer,
      interview_location: interview_location,
    )

    get "/api/communities/cool_community/stories/123"

    expect(response).to have_http_status(:ok)
    expect(json_response.keys).to include(
      "interviewer",
      "interviewLocation",
    )
  end
end
