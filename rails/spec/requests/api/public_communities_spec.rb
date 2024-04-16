require 'rails_helper'

RSpec.describe "Public Communities Endpoint", type: :request do
  let!(:public_community) { FactoryBot.create(:public_community, name: "Cool Community") }
  let!(:community) { FactoryBot.create(:community, name: "Private Community") }

  it "returns an array of public communities" do
    get "/api/communities"

    expect(json_response.length).to eq(1)
    expect(json_response.first).to include({
      "name" => "Cool Community",
      "slug" => "cool_community"
    })
  end

  it "includes the community's display image" do
    get "/api/communities"
    expect(json_response.first.keys).not_to include("displayImage")

    public_community.display_image.attach(io: File.open("./spec/fixtures/media/terrastories.png"), filename: 'file.pdf')

    get "/api/communities"
    expect(json_response.first.keys).to include("displayImage")
  end

  context "static map image" do
    context "when mapbox is configured" do
      before { allow(Map).to receive(:use_mapbox?).and_return(true) }

      it "returns static map image url" do
        public_community.theme.static_map.attach(io: file_fixture("../media/terrastories.png").open, filename: "static_map.png")

        get "/api/communities"
        expect(json_response.first.keys).to include("staticMapUrl")
        expect(json_response.first["staticMapUrl"]).to eq(blob_url(public_community.theme.static_map))
      end

      it "returns nil if no static map" do
        get "/api/communities"
        expect(json_response.first.keys).not_to include("staticMapUrl")
      end
    end

    context "when maplibre is configured" do
      it "returns nil, even if static map had previously been attached" do
        public_community.theme.static_map.attach(io: file_fixture("../media/terrastories.png").open, filename: "static_map.png")

        get "/api/communities"
        expect(json_response.first.keys).not_to include("staticMapUrl")
      end
    end
  end

  context "with search" do
    it "can be filtered with case insensitive query" do
      get "/api/communities", params: {search: "cool"}
      expect(json_response.length).to eq(1)
    end

    it "only returns matching results" do
      get "/api/communities", params: {search: "nope"}
      expect(json_response.length).to eq(0)
    end
  end
end
