### Setup for MapGL services ###
# This configures for both online (mapbox-gl) and offline (maplibre-gl)
# however only one configuration is used by the app.

# By default, local map / offline mode is turned off.
Rails.application.config.offline_mode = false

#######################
## Online Configuration
# !!!! NOTE: If you are setting up your own online instance,
# please utilize your Community's settings page to configure
# your mapbox access token and preferred map style! These
# are only meant to be FALLBACK values.

# == Default Mapbox Token
# The default mapbox token is used to provide a base mapbox token
# to render maps, even when one is not provided by the user.
# Mapbox tokens are set per-community in-app.
Rails.application.config.default_mapbox_token = ENV["DEFAULT_MAPBOX_TOKEN"] || ENV["MAPBOX_ACCESS_TOKEN"] || "pk.ey"

# == Default Map Style
# The default map style is used to provide a default-style for map
# rendering. It's configurable per-community via settings to override
# what is defined here.
Rails.application.config.default_map_style = ENV["DEFAULT_MAP_STYLE"] || ENV["MAPBOX_STYLE"] || "mapbox://styles/mapbox/streets-v11"

########################
## Offline Configuration
if Rails.env.offline? || ENV["OFFLINE_MODE"]&.downcase == "yes"
  Rails.application.config.offline_mode = true
end

if ENV["USE_LOCAL_MAP_SERVER"].present? || ENV["OFFLINE_MAP_STYLE"].present?
  Rails.application.config.default_map_style = ENV["OFFLINE_MAP_STYLE"]
end
