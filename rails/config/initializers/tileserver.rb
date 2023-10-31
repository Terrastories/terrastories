Rails.application.config.offline_mode = Rails.env.offline? || ENV["OFFLINE_MODE"]&.downcase == "yes"
Rails.application.config.use_protomaps = false
Rails.application.config.use_maplibre = false

# Always set mapbox configuration when available;
# This is the default fallback barring no other configuration.
Rails.application.config.x.map_config.mapbox_token = ENV["DEFAULT_MAPBOX_TOKEN"] || ENV["MAPBOX_ACCESS_TOKEN"] || "pk.ey"
Rails.application.config.x.map_config.map_style = ENV["DEFAULT_MAP_STYLE"] || ENV["MAPBOX_STYLE"] || "mapbox://styles/mapbox/streets-v11"

# Backwards compatible Maps using Tileserver
if ENV["TILESERVER_URL"].present? || ENV["OFFLINE_MAP_STYLE"].present?
  Rails.application.config.use_maplibre = true
  Rails.application.config.x.map_config.map_style = ENV["TILESERVER_URL"].presence || ENV["OFFLINE_MAP_STYLE"].presence
end

# Optionally, you may use protomaps (pmtiles) rather than mbtiles w/ a Tileserver
# If you have a `TILESERVER_URL` configured, we will not load protomaps even with
# `USE_PROTOMAPS` set.
# However, if you have `OFFLINE_MAP_STYLE` set with `USE_PROTOMAPS`, Terrastories
# will load `OFFLINE_MAP_STYLE`  using protomaps rather than tileserver. To ensure
# loading with Tileserver, switch your `OFFLINE_MAP_STYLE` to `TILESERVER_URL`.
if ENV["USE_PROTOMAPS"] && !ENV["TILESERVER_URL"].present?
  Rails.application.config.use_maplibre = true
  Rails.application.config.use_protomaps = true
  if Rails.env.production? || ENV["STYLE_JSON_URL"].present?
    # Production environments require an online accessible PMTILES url and
    # correctly configured style.json file pointing to the pmtiles://{source}
    # and appropriate glyphs and sprites.
    Rails.application.config.x.map_config.tiles =  ENV["PMTILES_URL"]
    Rails.application.config.x.map_config.map_style =  ENV["STYLE_JSON_URL"]
  else
    # Non-production environments can read from OFFLINE_MAP_STYLE
    # with configured Docker volume
    # protocol, host, port = Rails.application.routes.default_url_options.values_at(:protocol, :host, :port)
    # Rails.application.config.x.map_config.tiles = "#{protocol ? protocol : 'http'}://#{host}#{port ? ":#{port}" : ''}/map/#{ENV.fetch("OFFLINE_MAP_STYLE", "terrastories-default")}/tiles.pmtiles"
    # Rails.application.config.x.map_config.map_style = "#{protocol ? protocol : 'http'}://#{host}#{port ? ":#{port}" : ''}/map/#{ENV.fetch("OFFLINE_MAP_STYLE", "terrastories-default")}/style.json"
    Rails.application.config.x.map_config.tiles = "http://localhost:3000/map/#{ENV.fetch("OFFLINE_MAP_STYLE", "terrastories-default")}/tiles.pmtiles"
    Rails.application.config.x.map_config.map_style = "http://localhost:3000/map/#{ENV.fetch("OFFLINE_MAP_STYLE", "terrastories-default")}/style.json"
  end
end
