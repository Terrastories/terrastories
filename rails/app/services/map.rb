class Map
  class << self
    # Offline Configuration
    #
    # When true, Map configuration is forced into offline compatible maps.
    # - Mapbox configuration is ignored
    # - Protomaps API key is ignored
    # - Locally accessible map packages are used (default, or configured)
    def offline?
      return @_offline if defined? @_offline
      @_offline = Rails.env.offline? || ["yes", "y", "true", "t"].include?(ENV["OFFLINE_MODE"]&.downcase)
    end

    # Configure Mapbox
    #
    # By default, Terrastories uses MapLibre with a free Protomaps API key.
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
      @_default_style = new(use_mapbox?, offline?).style
    end

    # Test Helper to reset memoization in the same thread.
    # In other environments, rebooting will remove cache.
    def reload
      return unless Rails.env.test?

      self.send(:remove_instance_variable, :@_offline) if defined? @_offline
      self.send(:remove_instance_variable, :@_use_mapbox) if defined? @_use_mapbox
      self.send(:remove_instance_variable, :@_mapbox_access_token) if defined? @_mapbox_access_token
      self.send(:remove_instance_variable, :@_default_style) if defined? @_default_style
    end
  end

  def initialize(use_mapbox, offline)
    @use_mapbox = use_mapbox
    @offline = offline
    @protocol, @host, @port = Rails.application.routes.default_url_options.values_at(:protocol, :host, :port)
  end

  def style
    configured_style
  end

  private

  def configured_style
    return @_configured_style if defined? @_configured_style

    @_configured_style = if @use_mapbox
      ActiveSupport::Deprecation.warn(
        "Setting DEFAULT_MAP_STYLE to configure Mapbox is deprecated. " \
        "Use MAPBOX_STYLE instead."
      ) if ENV["DEFAULT_MAP_STYLE"]
      ENV["DEFAULT_MAP_STYLE"] || ENV["MAPBOX_STYLE"] || "mapbox://styles/mapbox/streets-v11"
    elsif !@offline && (protomaps_api_key = ENV["PROTOMAPS_API_KEY"])
      "https://api.protomaps.com/tiles/v3.json?key=#{protomaps_api_key}"
    else
      ActiveSupport::Deprecation.warn(
        "Setting OFFLINE_MAP_STYLE to configure Tileserver is deprecated. " \
        "Use TILESERVER_URL instead."
      ) if ENV["OFFLINE_MAP_STYLE"]
      ENV["OFFLINE_MAP_STYLE"] || ENV["TILESERVER_URL"]
    end
  end
end