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
      it "[deprecated] returns OFFLINE_MAP_STYLE" do
        allow(ENV).to receive(:[]).with("OFFLINE_MAP_STYLE").and_return("https://localhost:8080/terrastories-default/style.json")
        expect(ActiveSupport::Deprecation).to receive(:warn).with(
          "Setting OFFLINE_MAP_STYLE to configure Tileserver is deprecated. " \
          "Use TILESERVER_URL instead."
        )
        expect(Map.default_style).to eq("https://localhost:8080/terrastories-default/style.json")
      end
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

  describe "local map packages" do
    context "when offline map style is configured" do
      it "returns DEFAULT_MAP_PACKAGE" do
        allow(ENV).to receive(:fetch).with("DEFAULT_MAP_PACKAGE", any_args).and_return("custom-map-style")

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

  describe "#default_fonts" do
    it "defaults to Noto Sans Medium" do
      expect(Map.default_fonts).to contain_exactly("Noto Sans Medium")
    end

    context "when using Mapbox" do
      before do
        allow(Map).to receive(:use_mapbox?).and_return(true)
        # ensure no outgoing calls are triggered
        allow(Net::HTTP).to receive(:get_response)
      end

      it "correctly follows redirects if necessary" do
        response = Net::HTTPRedirection.new(1.0, "307", "Redirect")
        allow(response).to receive(:[]).with("location").and_return("http://follow.me")
        expect(Net::HTTP).to receive(:get_response).with(URI("https://api.mapbox.com/fonts/v1/mapbox/Noto%20Sans%20Bold/0-255.pbf?access_token=")).and_return(response).once
        expect(Net::HTTP).to receive(:get_response).with(URI("http://follow.me")).and_return(Net::HTTPSuccess.new(1.0, "200", "OK")).once

        expect(Warning).to receive(:warn).with(/redirected to http:\/\/follow.me/)
        expect(Map.default_fonts).to contain_exactly("Noto Sans Bold")
      end

      it "returns Noto Sans Bold if font is available on user access token" do
        expect(Net::HTTP).to receive(:get_response).with(URI("https://api.mapbox.com/fonts/v1/mapbox/Noto%20Sans%20Bold/0-255.pbf?access_token=")).and_return(Net::HTTPSuccess.new(1.0, "200", "OK")).once
        expect(Map.default_fonts).to contain_exactly("Noto Sans Bold")
      end

      it "returns Noto Sans Medium if font is available on user access token but not Noto Sans Bold" do
        expect(Net::HTTP).to receive(:get_response).with(URI("https://api.mapbox.com/fonts/v1/mapbox/Noto%20Sans%20Bold/0-255.pbf?access_token=")).and_return(Net::HTTPNotFound.new(1.0, "404", "Not Found")).once
        expect(Net::HTTP).to receive(:get_response).with(URI("https://api.mapbox.com/fonts/v1/mapbox/Noto%20Sans%20Medium/0-255.pbf?access_token=")).and_return(Net::HTTPSuccess.new(1.0, "200", "OK")).once
        expect(Map.default_fonts).to contain_exactly("Noto Sans Medium")
      end

      it "fallsback to Open Sans Bold" do
        expect(Net::HTTP).to receive(:get_response).with(any_args).and_return(Net::HTTPNotFound.new(1.0, "404", "Not Found")).twice
        # correctly memoizes values
        expect(Map.default_fonts).to contain_exactly("Open Sans Bold")
        expect(Map.default_fonts).to contain_exactly("Open Sans Bold")
        expect(Map.default_fonts).to contain_exactly("Open Sans Bold")
      end
    end

    context "when offline" do
      before { allow(Map).to receive(:offline?).and_return(true) }

      it "and TILESERVER_URL is set it returns Noto Sans Bold and Noto Sans Regular" do
        allow(ENV).to receive(:[]).with("TILESERVER_URL").and_return("offlinestyle")
        expect(Map.default_fonts).to contain_exactly("Noto Sans Bold", "Noto Sans Regular")
      end

      it "and PROTOMAPS_API_KEY is set it returns Noto Sans Medium" do
        allow(ENV).to receive(:[]).with("PROTOMAPS_API_KEY").and_return("0123123213")
        expect(Map.default_fonts).to contain_exactly("Noto Sans Medium")
      end
    end
  end
end
