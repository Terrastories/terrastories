class Map
  class << self
    # Offline Configuration
    #
    # When true, Map configuration is forced into offline compatible maps.
    # - Mapbox configuration is ignored
    # - Protomaps API key is ignored
    # - Local map styles with .pmtiles are used (default, or configured)
    def offline?
      return @_offline if defined? @_offline
      @_offline = Rails.env.offline? || ["yes", "y", "true", "t"].include?(ENV["OFFLINE_MODE"]&.downcase)
    end

    # Configure Mapbox
    #
    # By default, Terrastories uses MapLibre with a free Protomaps API key
    # or a local pmtiles map package when an API key is not set.
    #
    # In order to utilize Mapbox as your default map fallback renderer,
    # you must:
    # - Run in an "online" configuration
    # - MAPBOX_ACCESS_TOKEN must have a valid access token from Mapbox
    def use_mapbox?
      return false if offline?

      return @_use_mapbox if defined? @_use_mapbox
      @_use_mapbox = !!mapbox_access_token
    end

    def mapbox_access_token
      return @_mapbox_access_token if defined? @_mapbox_access_token

      if (token = ENV["DEFAULT_MAPBOX_TOKEN"])
        ActiveSupport::Deprecation.warn(
          "Setting DEFAULT_MAPBOX_TOKEN to configure Mapbox is deprecated. " \
          "Use MAPBOX_ACCESS_TOKEN instead."
        )
      end

      @_mapbox_access_token = token || ENV["MAPBOX_ACCESS_TOKEN"]
    end

    def default_style
      return @_default_style if defined? @_default_style
      @_default_style = new.style
    end

    def default_tiles
      return @_default_tiles if defined? @_default_tiles
      @_default_tiles = new.tiles
    end

    def default_fonts
      return @_default_fonts if defined? @_default_fonts
      @_default_fonts = new.style_fonts
    end

    # Test Helper to reset memoization in the same thread.
    # In other environments, rebooting will remove cache.
    def reload
      return unless Rails.env.test?

      self.send(:remove_instance_variable, :@_offline) if defined? @_offline
      self.send(:remove_instance_variable, :@_use_mapbox) if defined? @_use_mapbox
      self.send(:remove_instance_variable, :@_mapbox_access_token) if defined? @_mapbox_access_token
      self.send(:remove_instance_variable, :@_default_style) if defined? @_default_style
      self.send(:remove_instance_variable, :@_default_tiles) if defined? @_default_tiles
      self.send(:remove_instance_variable, :@_default_fonts) if defined? @_default_fonts
    end
  end

  def initialize
    @protocol, @host, @port = Rails.application.routes.default_url_options.values_at(:protocol, :host, :port)
  end

  def style
    configured_style || map_style
  end

  def tiles
    map_tiles unless configured_style
  end

  def style_fonts
    # Online & using Mapbox
    if Map.use_mapbox?
      username = configured_style[/(?<=styles\/)\w+/]
      if style_has_font?("https://api.mapbox.com/fonts/v1/#{username}/Noto%20Sans%20Bold/0-255.pbf?access_token=#{Map.mapbox_access_token}")
        ["Noto Sans Bold"]
      elsif style_has_font?("https://api.mapbox.com/fonts/v1/#{username}/Noto%20Sans%20Medium/0-255.pbf?access_token=#{Map.mapbox_access_token}")
        ["Noto Sans Medium"]
      else
        # our previous default, and the default classic Mapbox font
        ["Open Sans Bold"]
      end
    elsif Map.offline? && configured_style.present?
      # Tileserver GL will automatically attempt to use a fallback font family with the same
      # style (Noto Sans Bold -> Open Sans Bold -> Noto Sans Regular -> Open Sans Regular -> Open Sans).
      ["Noto Sans Bold", "Noto Sans Regular"]
    else
      # Our default PMtiles and protomaps all use Noto Sans
      ["Noto Sans Medium"]
    end
  end

  private

  def configured_style
    return @_configured_style if defined? @_configured_style

    @_configured_style = if Map.use_mapbox?
      ActiveSupport::Deprecation.warn(
        "Setting DEFAULT_MAP_STYLE to configure Mapbox is deprecated. " \
        "Use MAPBOX_STYLE instead."
      ) if ENV["DEFAULT_MAP_STYLE"]
      ENV["DEFAULT_MAP_STYLE"] || ENV["MAPBOX_STYLE"] || "mapbox://styles/mapbox/streets-v11"
    elsif !Map.offline? && (protomaps_api_key = ENV["PROTOMAPS_API_KEY"])
      "https://api.protomaps.com/tiles/v3.json?key=#{protomaps_api_key}"
    elsif (ENV["OFFLINE_MAP_STYLE"])
      ActiveSupport::Deprecation.warn(
        "Setting OFFLINE_MAP_STYLE to configure Tileserver is deprecated. " \
        "Use TILESERVER_URL instead."
      )
      ENV["OFFLINE_MAP_STYLE"]
    else
      ENV["TILESERVER_URL"]
    end
  end

  def map_style
    online_pmtiles[0] || local_map_package[0]
  end

  def map_tiles
    online_pmtiles[1] || local_map_package[1]
  end

  def local_map_package
    style = ENV.fetch("DEFAULT_MAP_PACKAGE", "terrastories-map")

    protocol, host, port = Rails.application.routes.default_url_options.values_at(:protocol, :host, :port)
    [
      "#{protocol ? protocol : 'http'}://#{host}#{port ? ":#{port}" : ''}/map/#{style}/style.json",
      "#{protocol ? protocol : 'http'}://#{host}#{port ? ":#{port}" : ''}/map/#{style}/tiles.pmtiles"
    ]
  end

  def online_pmtiles
    style_json = ENV["STYLE_JSON_URL"]
    pmtiles = ENV["PMTILES_URL"]

    if style_json && pmtiles
      [style_json, pmtiles]
    else
      [nil, nil]
    end
  end

  def style_has_font?(uri_str, limit = 1)
    return false if limit < 0

    response = Net::HTTP.get_response(URI(uri_str))

    case response
    when Net::HTTPSuccess then
      true
    when Net::HTTPNotFound then
      false
    when Net::HTTPRedirection then
      location = response['location']
      warn "redirected to #{location}"
      style_has_font?(location, limit - 1)
    else
      false
    end
  end
end
