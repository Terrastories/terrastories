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

  describe "#basemap_style" do
    it "returns 'contrast' with default configuration" do
      expect(theme.basemap_style).to eq("contrast")
    end

    it "returns configured protomaps_basemap_style even without protomaps API key" do
      theme.protomaps_basemap_style = "light"
      expect(theme.basemap_style).to eq("light")
    end

    context "when offline" do
      it "returns 'default'" do
        expect(Map).to receive(:offline?).and_return(true)
        expect(theme.basemap_style).to eq("default")
      end
    end

    context "when default map is mapbox" do
      before { allow(Map).to receive(:use_mapbox?).and_return(true) }

      it "returns 'default'" do
        # this value should be ignored
        theme.protomaps_basemap_style = "light"
        expect(theme.basemap_style).to eq("default")
      end

      it "returns 'contrast' if protomaps is configured" do
        theme.protomaps_api_key = "123123123"
        expect(theme.basemap_style).to eq("contrast")
      end
    end

    context "when community has mapbox configured" do
      it "returns 'default'" do
        theme.mapbox_access_token = "pk.eyTest"
        theme.protomaps_basemap_style = "light"
        expect(theme.basemap_style).to eq("default")
      end
    end
  end

  describe "#mapbox_token" do
    it "returns nil by default" do
      expect(theme.mapbox_token).to be_nil
    end

    it "returns server configured token" do
      theme.mapbox_access_token = "custom"
      expect(theme.mapbox_token).to eq("custom")
    end

    context "when server is configured for mapbox" do
      before { allow(Map).to receive(:mapbox_access_token).and_return("pk.eyTest") }

      it "returns default server configured token" do
        expect(theme.mapbox_token).to eq("pk.eyTest")
      end

      it "returns community configured token when available" do
        theme.mapbox_access_token = "custom"
        expect(theme.mapbox_token).to eq("custom")
      end
    end
  end

  describe "#map_style_url" do
    context "when offline" do
      it "returns default configured style" do
        expect(Map).to receive(:offline?) { true }
        expect(Map).to receive(:default_style) { "default_style" }

        expect(theme.map_style_url).to eq("default_style")
      end
    end

    it "returns community configured mapbox style" do
      theme.mapbox_access_token = "pk.eyTest"
      theme.mapbox_style_url = "mapbox://style"
      expect(theme.map_style_url).to eq("mapbox://style")
    end

    it "returns protomaps tile json url" do
      theme.mapbox_access_token = "pk.eyTest"
      theme.mapbox_style_url = "mapbox://style"
      theme.protomaps_api_key = "123123123"
      expect(theme.map_style_url).to eq("https://api.protomaps.com/tiles/v3.json?key=123123123")
    end

    it "returns default protomaps tile json url" do
      expect(ENV).to receive(:[]).with("PROTOMAPS_API_KEY").and_return("CUSTOM")
      expect(theme.map_style_url).to eq("https://api.protomaps.com/tiles/v3.json?key=CUSTOM")
    end

    context "when community has mapbox configured" do
      it "returns default configured style" do
        expect(Map).to receive(:default_style) { "default_style" }

        expect(theme.map_style_url).to eq("default_style")
      end
    end
  end
end
