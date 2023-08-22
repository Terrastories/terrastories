require 'rails_helper'

RSpec.describe "Public Place Endpoint", type: :request do
  let!(:community) { FactoryBot.create(:community, public: true, name: "ATALM Testing", slug: "atalm") }
  let!(:place) { FactoryBot.create(:place_with_stories, story_count: 2, community: community, id: 123) }
  let!(:public_story) do
    FactoryBot.create(
      :story_with_speakers,
      places: [place],
      community: community,
      title: "Public Communities Work",
      desc: "Terrastories Dev discusses the design and architecture behind the new Public Communities interface",
      permission_level: :anonymous
    )
  end
  let!(:restricted_story) do
    FactoryBot.create(
      :story_with_speakers,
      places: [place],
      community: community,
      title: "Restricted Community Work",
      desc: "Terrastories Dev working on new features that are not ready to be publicized yet!",
      permission_level: :user_only
    )
  end


  def json_response
    JSON.parse(response.body)
  end

  it "returns a 404 not found if community is not found" do
    get "/api/communities/unknown/places/123"

    expect(response).to have_http_status(:not_found)
  end

  it "returns a 404 not found if place is not found" do
    get "/api/communities/atalm/places/unknown"

    expect(response).to have_http_status(:not_found)
  end

  it "returns an array of public communities" do
    get "/api/communities/atalm/places/123"

    expect(json_response.keys).to contain_exactly(
      "id",
      "name",
      "description",
      "region",
      "placenameAudio",
      "typeOfPlace",
      "stories",
      "points"
    )
  end

  it "includes the places stories" do
    get "/api/communities/atalm/places/123"

    expect(json_response["stories"].length).to eq(1)
    expect(json_response["stories"].first).to include(
      "id" => public_story.id,
      "title" => public_story.title,
      "topic" => public_story.topic,
      "desc" => public_story.desc,
      "language" => public_story.language
    )
  end
end
