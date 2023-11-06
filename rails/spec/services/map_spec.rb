require "rails_helper"

RSpec.describe Map do
  before do
    Map.reload
  end

  describe "#offline?" do
    it "returns true if Rails.env.offline?" do
      allow(Rails).to receive(:env).and_return("offline".inquiry).once
      expect(Map.offline?).to be true
    end

    it "returns true if Rails.env.offline?" do
      allow(ENV).to receive(:[]).with("OFFLINE_MODE").and_return("yes")
      expect(Map.offline?).to be true
    end

    it "returns false" do
      expect(Map.offline?).to be false
    end

    it "memoizes value" do
      expect(Rails.env).to receive(:offline?).and_return(false).once
      expect(ENV).to receive(:[]).with("OFFLINE_MODE").and_return("t").once

      Map.offline?
      # subsequent calls should not trigger additional checks
      Map.offline?
      Map.offline?
    end
  end

  describe "#use_mapbox?" do
    it "returns false if running in offline mode even if mapbox is configured" do
      allow(Map).to receive(:offline?).and_return(true)

      expect(ENV).not_to receive(:[]).with("MAPBOX_ACCESS_TOKEN")
      expect(ENV).not_to receive(:[]).with("DEFAULT_MAPBOX_TOKEN")

      expect(Map.use_mapbox?).to be false
    end

    context "returns true" do
      it "when MAPBOX_ACCESS_TOKEN is set" do
        allow(ENV).to receive(:[]).with("MAPBOX_ACCESS_TOKEN").and_return("pk.ey")
        expect(Map.use_mapbox?).to be true
      end

      it "when [deprecated] DEFAULT_MAPBOX_TOKEN is set" do
        allow(ENV).to receive(:[]).with("DEFAULT_MAPBOX_TOKEN").and_return("pk.ey")

        expect(ActiveSupport::Deprecation).to receive(:warn).with(
          "Setting DEFAULT_MAPBOX_TOKEN to configure Mapbox is deprecated. " \
          "Use MAPBOX_ACCESS_TOKEN instead."
        )
        expect(Map.use_mapbox?).to be true
      end
    end

    it "returns false when no mapbox configuration is set" do
      allow(ENV).to receive(:[]).with("MAPBOX_ACCESS_TOKEN")
      allow(ENV).to receive(:[]).with("DEFAULT_MAPBOX_TOKEN")
      expect(Map.use_mapbox?).to be false
    end
  end

  describe "#default_style" do
    context "when mapbox is configured" do
      before { allow(Map).to receive(:use_mapbox?).and_return(true) }

      it "returns [deprecated] DEFAULT_MAP_STYLE" do
        allow(ENV).to receive(:[]).with("DEFAULT_MAP_STYLE").and_return("mapbox://styles/terrastories/custom-v1")
        # shouldn't use fallback
        expect(ENV).not_to receive(:[]).with("MAPBOX_STYLE")

        expect(ActiveSupport::Deprecation).to receive(:warn).with(
          "Setting DEFAULT_MAP_STYLE to configure Mapbox is deprecated. " \
          "Use MAPBOX_STYLE instead."
        )

        expect(Map.default_style).to eq("mapbox://styles/terrastories/custom-v1")
      end

      it "returns MAPBOX_STYLE" do
        expect(ENV).to receive(:[]).with("DEFAULT_MAP_STYLE")
        expect(ENV).to receive(:[]).with("MAPBOX_STYLE").and_return("mapbox://styles/terrastories/custom-v2")

        expect(Map.default_style).to eq("mapbox://styles/terrastories/custom-v2")
      end

      it "fallsback to a default mapbox managed style" do
        expect(ENV).to receive(:[]).with("DEFAULT_MAP_STYLE")
        expect(ENV).to receive(:[]).with("MAPBOX_STYLE")

        expect(Map.default_style).to eq("mapbox://styles/mapbox/streets-v11")
      end
    end

    context "when tileserver is configured" do
      it "returns TILESERVER_URL" do
        allow(ENV).to receive(:[]).with("TILESERVER_URL").and_return("https://tileserver.terrastories.app/style.json")

        expect(Map.default_style).to eq("https://tileserver.terrastories.app/style.json")
      end
    end

    context "when protomaps API key is configured" do
      it "returns protomaps tilesjson w/ configured API key" do
        allow(ENV).to receive(:[]).with("PROTOMAPS_API_KEY").and_return("1234567890")

        expect(Map.default_style).to eq("https://api.protomaps.com/tiles/v3.json?key=1234567890")
      end
    end
  end

  describe "online hosted pmtiles" do
    context "when both STYLE_JSON_URL and PMTILES_URL is set" do
      it "returns online pmtiles style & tiles" do
        allow(ENV).to receive(:[]).with("STYLE_JSON_URL").and_return("https://s3.aws.com/bucket/style.json")
        allow(ENV).to receive(:[]).with("PMTILES_URL").and_return("https://s3.aws.com/bucket/tiles.pmtiles")
        expect(Map.default_style).to eq("https://s3.aws.com/bucket/style.json")
        expect(Map.default_tiles).to eq("https://s3.aws.com/bucket/tiles.pmtiles")
      end
    end

    context "when only PMTILES_URL or STYLE_JSON_URL is configured" do
      it "returns default map package" do
        allow(ENV).to receive(:[]).with("STYLE_JSON_URL").and_return("https://s3.aws.com/bucket/style.json")
        expect(Map.default_style).to eq("http://localhost:3000/map/terrastories-map/style.json")
        expect(Map.default_tiles).to eq("http://localhost:3000/map/terrastories-map/tiles.pmtiles")
      end

      it "returns default map package" do
        allow(ENV).to receive(:[]).with("PMTILES_URL").and_return("https://s3.aws.com/bucket/style.json")
        expect(Map.default_style).to eq("http://localhost:3000/map/terrastories-map/style.json")
        expect(Map.default_tiles).to eq("http://localhost:3000/map/terrastories-map/tiles.pmtiles")
      end
    end
  end

  describe "offline map pmtiles" do
    context "when offline map style is configured" do
      it "returns OFFLINE_MAP_STYLE" do
        allow(ENV).to receive(:fetch).with("OFFLINE_MAP_STYLE", any_args).and_return("custom-map-style")

        expect(Map.default_style).to eq("http://localhost:3000/map/custom-map-style/style.json")
        expect(Map.default_tiles).to eq("http://localhost:3000/map/custom-map-style/tiles.pmtiles")
      end
    end

    context "when no map configuration is set" do
      it "returns default offline map hosted at configured hostname if running in offline mode" do
        allow(Map).to receive(:offline?).and_return(true)
        allow(Rails.application.routes.default_url_options).to receive(:values_at).and_return(["http", "custom.local", nil])
        expect(Map.default_style).to eq("http://custom.local/map/terrastories-map/style.json")
        expect(Map.default_tiles).to eq("http://custom.local/map/terrastories-map/tiles.pmtiles")
      end

      it "returns default offline map hosted at localhost:3000" do
        expect(Map.default_style).to eq("http://localhost:3000/map/terrastories-map/style.json")
        expect(Map.default_tiles).to eq("http://localhost:3000/map/terrastories-map/tiles.pmtiles")
      end
    end
  end

  describe "[deprecated] offline map style set to tileserver" do
    it "returns offline map style url as-is if set as tileserver url" do
      allow(ENV).to receive(:fetch).with("OFFLINE_MAP_STYLE", any_args).and_return("http://tileserver.local/custom-map-style/style.json")
      expect(Map.default_style).to eq("http://tileserver.local/custom-map-style/style.json")
    end
  end
end
