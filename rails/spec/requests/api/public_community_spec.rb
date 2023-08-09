require 'rails_helper'

RSpec.describe "Public Community (show) Endpoint", type: :request do
  let!(:public_community) { FactoryBot.create(:public_community, name: "Cool Community") }

  def json_response
    JSON.parse(response.body)
  end

  it "returns 404 when community can't be found" do
    get "/api/communities/unknown"

    expect(response).to have_http_status(:not_found)
  end

  it "returns a community's public details" do
    get "/api/communities/cool_community"

    expect(json_response).to include(
      "name",
      "slug",
      "storiesCount",
      "details",
      "points",
      "categories",
      "filters",
      "mapConfig"
    )
  end

  context "community data" do
    it "includes community details for landing panel" do
      get "/api/communities/cool_community"

      expect(json_response["details"]).to include(
        "name" => "Cool Community",
        "description" => nil,
        "sponsorLogos" => []
      )
    end

    # note(LM): Eventually, we can make which categories are
    # offered configurable by community admins
    it "includes community filter categories for landing panel" do
      get "/api/communities/cool_community"

      expect(json_response["categories"]).to contain_exactly(*Community::FILTERABLE_ATTRIBUTES)
    end

    it "includes community map config" do
      get "/api/communities/cool_community"

      expect(json_response["mapConfig"]).to include(
        "mapboxAccessToken",
        "mapboxStyle",
        "mapbox3dEnabled",
        "mapProjection",
        "centerLat",
        "centerLong",
        "swBoundaryLat",
        "swBoundaryLong",
        "neBoundaryLat",
        "neBoundaryLong",
        "center",
        "maxBounds",
        "zoom",
        "pitch",
        "bearing"
      )
    end
  end
end
