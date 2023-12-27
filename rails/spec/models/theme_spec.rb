require 'rails_helper'

RSpec.describe Theme, type: :model do
  let(:theme) {FactoryBot.create(:theme, community: FactoryBot.create(:community))}

  it "raises an error with invalid center latitude" do
    expect do
      theme.center_lat = 100
      theme.save!
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Latitude value should be between -90 and 90")
  end

  it "sets default map values from model if none are provided on creation" do
    expect(theme.zoom).to eq 2
  end

  it "updates map values as appropriate" do
    expect do
      theme.zoom = 7
    end.to change(theme, :zoom).from(2).to(7)
  end

  it "returns map points as an array of longitude and latitude" do
    expect(theme.center).to be_an_instance_of Array
    expect(theme.center).to eq [0, 15]
    expect(theme.sw_boundary).to eq nil # was [-180, -85]
    expect(theme.ne_boundary).to eq nil # was [180, 85]
  end

  context "map config" do
    describe "#mapbox_token" do
      context "when community has Mapbox configured" do
        before do
          theme.update(
            mapbox_access_token: "pk.ey",
            mapbox_style_url: "mapbox://styles/user/custom-v11"
          )
        end

        it "returns community configured Mapbox access token" do
          expect(theme.mapbox_token).to eq("pk.ey")
        end

        it "returns nil if configured for offline" do
          allow(Map).to receive(:offline?).and_return(true)

          expect(theme.mapbox_token).to be_nil
        end
      end

      it "returns default mapbox access token when configured by server" do
        allow(Map).to receive(:mapbox_access_token).and_return("pk.eyDefault")
        expect(theme.mapbox_token).to eq("pk.eyDefault")
      end

      it "returns nil by default" do
        expect(theme.mapbox_token).to be_nil
      end
    end

    describe "#map_tiles" do
      it "returns Map.default_tiles" do
        expect(theme.map_tiles).to eq("http://localhost:3000/map/terrastories-map/tiles.pmtiles")
      end
    end

    describe "#map_style" do
      context "when community has Mapbox configured" do
        before do
          theme.update(
            mapbox_access_token: "pk.ey",
            mapbox_style_url: "mapbox://styles/user/custom-v11"
          )
        end

        it "returns community configured Mapbox style" do
          expect(theme.map_style).to eq("mapbox://styles/user/custom-v11")
        end

        it "returns nil if configured for offline" do
          allow(Map).to receive(:offline?).and_return(true)

          expect(theme.map_style).to eq("http://localhost:3000/map/terrastories-map/style.json")
        end
      end

      it "returns default configured map style" do
        allow(Map).to receive(:default_style).and_return("mapbox://styles/default/style-v1")
        expect(theme.map_style).to eq("mapbox://styles/default/style-v1")
      end
    end

    describe "#use_maplibre?" do
      context "when running in offline mode" do
        before do
          allow(Map).to receive(:offline?) { true }
        end

        it "uses maplibre" do
          expect(theme.use_maplibre?).to be true
        end

        it "uses maplibre even if mapbox access token is available" do
          theme.update(mapbox_access_token: "pk.ey", mapbox_style_url: "mapbox://")
          expect(theme.use_maplibre?).to be true
        end

        it "uses maplibre even if Mapbox is the default configuration" do
          allow(Map).to receive(:use_mapbox?).and_return(true)
          expect(theme.use_maplibre?).to be true
        end
      end

      context "when running in online mode" do
        it "uses maplibre by default" do
          expect(theme.use_maplibre?).to be true
        end

        it "uses mapbox if mapbox access token is set by the community" do
          theme.update(mapbox_access_token: "pk.ey", mapbox_style_url: "mapbox://")
          expect(theme.use_maplibre?).to be false
        end

        it "uses mapbox if mapbox access token is the default configuration" do
          allow(Map).to receive(:use_mapbox?).and_return(true)
          expect(theme.use_maplibre?).to be false
        end
      end
    end
  end
end
