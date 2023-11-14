require "rails_helper"

RSpec.describe "Public Stories Endpoint", type: :request do
  let!(:community) { FactoryBot.create(:public_community, name: "Cool Community") }
  let!(:orphan_community) { FactoryBot.create(:public_community, name: "Orphaned Community") }

  it "returns 404 when community can't be found" do
    get "/api/communities/unknown/stories"

    expect(response).to have_http_status(:not_found)
  end

  it "returns a 404 when community is not public" do
    private_community = FactoryBot.create(:community)

    get "/api/communities/#{private_community.slug}/stories"

    expect(response).to have_http_status(:not_found)
  end

  it "returns total stories, array of stories, and geo feature collection of story points" do
    get "/api/communities/cool_community/stories"

    expect(response).to have_http_status(:ok)
    expect(json_response.keys).to contain_exactly("points", "stories")
    expect(json_meta.keys).to contain_exactly("total", "hasNextPage", "nextPageMeta")
  end

  context "filters and sort" do
    let!(:place_1) { create(:place, community: community, region: "the internet") }
    let!(:place_2) { create(:place, community: community, type_of_place: "online") }
    let!(:speaker_1) { create(:speaker, community: community) }
    let!(:speaker_2) { create(:speaker, community: community, speaker_community: "ruby for good") }

    # Story:
    # - place 2
    # - region: the internet
    # - type of place: online
    # - speaker 1
    let!(:story_1) do
      create(
        :story,
        title: "Zeta",
        community: community,
        places: [place_2],
        speakers: [speaker_1, speaker_2],
        permission_level: :anonymous
      )
    end

    # Story:
    # - place 1
    # - region: the internet
    # - speaker 2
    # - speaker community: ruby for good
    # - topic: tech
    let!(:story_2) do
      create(
        :story,
        title: "Omega",
        community: community,
        topic: "tech",
        places: [place_1],
        speakers: [speaker_2],
        permission_level: :anonymous
      )
    end

    # Story:
    # - place 1
    # - type of place: online
    # - speaker 1
    # - language: Spanish
    let!(:story_3) do
      create(
        :story,
        title: "Alpha",
        community: community,
        topic: "nonprofit work",
        language: "Spanish",
        places: [place_1],
        speakers: [speaker_1],
        permission_level: :anonymous
      )
    end

    it "correctly filters" do
      # filter by place (id / name)
      get "/api/communities/cool_community/stories", params: {places: [place_2.id]}

      expect(json_meta["total"]).to eq(1)
      expect(json_response["stories"].map { |s| s["id"] }).to contain_exactly(story_1.id)

      # filter by region
      get "/api/communities/cool_community/stories", params: {region: ["the internet"]}

      expect(json_meta["total"]).to eq(2)
      expect(json_response["stories"].map { |s| s["id"] }).to contain_exactly(story_2.id, story_3.id)

      # filter by type of place
      get "/api/communities/cool_community/stories", params: {type_of_place: ["online"]}

      expect(json_meta["total"]).to eq(1)
      expect(json_response["stories"].map { |s| s["id"] }).to contain_exactly(story_1.id)

      # filter by topic
      get "/api/communities/cool_community/stories", params: {topic: ["nonprofit work", "tech"]}

      expect(json_meta["total"]).to eq(2)
      expect(json_response["stories"].map { |s| s["id"] }).to contain_exactly(story_2.id, story_3.id)

      # filter by language
      get "/api/communities/cool_community/stories", params: {language: ["Spanish", "Other"]}

      expect(json_meta["total"]).to eq(1)
      expect(json_response["stories"].map { |s| s["id"] }).to contain_exactly(story_3.id)

      # filter by speaker
      get "/api/communities/cool_community/stories", params: {speakers: [speaker_1.id, speaker_2.id]}

      expect(json_meta["total"]).to eq(3)
      expect(json_response["stories"].map { |s| s["id"] }).to contain_exactly(story_1.id, story_2.id, story_3.id)

      # filter by speaker community
      get "/api/communities/cool_community/stories", params: {speaker_community: ["ruby for good"]}

      expect(json_meta["total"]).to eq(2)
      expect(json_response["stories"].map { |s| s["id"] }).to contain_exactly(story_1.id, story_2.id)
    end

    it "does not include stories without at least one place" do
      place_1.destroy!

      get "/api/communities/cool_community/stories"

      expect(json_meta["total"]).to eq(1)
      expect(json_response["stories"].map { |s| s["id"] }).to contain_exactly(story_1.id)
    end

    it "does not include stories without at least one speaker" do
      speaker_2.destroy!

      get "/api/communities/cool_community/stories"

      expect(json_meta["total"]).to eq(2)
      expect(json_response["stories"].map { |s| s["id"] }).to contain_exactly(story_1.id, story_3.id)
    end

    it "correctly sorts" do
      # alphabetical
      get "/api/communities/cool_community/stories", params: {sort_by: "title", sort_dir: "asc"}
      expect(json_response["stories"].map{ |s| s["title"] }).to eq(
        ["Alpha", "Omega", "Zeta"]
      )

      # reverse alphabetical (default: desc)
      get "/api/communities/cool_community/stories", params: {sort_by: "title"}
      expect(json_response["stories"].map{ |s| s["title"] }).to eq(
        ["Zeta", "Omega", "Alpha"]
      )

      # with filter
      get "/api/communities/cool_community/stories", params: {sort_by: "title", sort_dir: "asc", region: ["the internet"]}
      expect(json_response["stories"].map{ |s| s["title"] }).to eq(
        ["Alpha", "Omega"]
      )
    end

    it "correctly paginates with filters" do
      get "/api/communities/cool_community/stories", params: {limit: 1}

      expect(json_meta["total"]).to eq(3)
      expect(json_response["stories"].count).to eq(1)
      expect(json_meta["hasNextPage"]).to be true

      # filter down to one place
      get "/api/communities/cool_community/stories", params: {limit: 1, places: [place_2.id]}

      expect(json_meta["total"]).to eq(1)
      expect(json_response["stories"].count).to eq(1)
      expect(json_meta["hasNextPage"]).to be false
    end
  end
end
