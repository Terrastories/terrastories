Rails.application.config.offline_mode = false
Rails.application.config.default_mapbox_token = ENV["DEFAULT_MAPBOX_TOKEN"] || ENV["MAPBOX_ACCESS_TOKEN"] || "pk.ey"
Rails.application.config.default_map_style = ENV["DEFAULT_MAP_STYLE"] || ENV["MAPBOX_STYLE"] || "mapbox://styles/mapbox/streets-v11"

# Set up offline mode for local map server
if ENV["USE_LOCAL_MAP_SERVER"].present?
  Rails.application.config.offline_mode = true
  # and override default map style
  Rails.application.config.default_map_style = ENV["OFFLINE_MAP_STYLE"]
end

if Rails.env.offline?
  Rails.application.config.offline_mode = true
end
