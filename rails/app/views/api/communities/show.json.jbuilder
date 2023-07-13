json.(@community, :name, :slug, :description)

# Details are used specifically in the Explore Panel
json.details do
  json.(@community, :name, :description)
  json.sponsorLogos @community.sponsor_logos do |logo|
    json.url rails_blob_url(logo)
    json.blobId logo.blob.id
  end
  if @community.display_image.attached?
    json.displayImage rails_blob_url(@community.display_image)
  end
end

# Initial Map Configuration
stories = @community.stories.preload(:places).where(permission_level: :anonymous)
json.storiesCount stories.size
json.points stories.flat_map(&:public_points).uniq

# Side Panel Filter Categories
json.categories Community::FILTERABLE_ATTRIBUTES

# Side Panel Filter Options (generated from available content)
json.filters @community.filters

json.mapConfig do
  json.mapboxAccessToken @community.theme.mapbox_access_token
  json.mapboxStyle @community.theme.mapbox_style
  json.mapbox3dEnabled @community.theme.mapbox_3d
  json.mapProjection @community.theme.map_projection

  json.centerLat @community.theme.center_lat
  json.centerLong @community.theme.center_long
  json.swBoundaryLat @community.theme.sw_boundary_lat
  json.swBoundaryLong @community.theme.sw_boundary_long
  json.neBoundaryLat @community.theme.ne_boundary_lat
  json.neBoundaryLong @community.theme.ne_boundary_long

  json.center @community.theme.center
  json.maxBounds @community.theme.boundaries

  json.zoom @community.theme.zoom
  json.pitch @community.theme.pitch
  json.bearing @community.theme.bearing
end