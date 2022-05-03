json.stories stories do |story|
  json.extract! story, :title, :desc, :id, :created_at
  json.points story.places.map(&:point_geojson)
  json.places story.places
  json.language story.language
  json.media story.media do |media|
    json.id media.id
    json.url url_for(media)
    json.blob media.blob
  end
  json.speakers story.speakers do |speaker|
    json.id speaker.id
    json.name speaker.name
    json.picture_url speaker.picture_url
    json.speaker_community speaker.speaker_community
  end

  json.media_links story.media_links do |media_link|
    json.id media_link.id
    json.url media_link.url
  end
  json.permission_level story.permission_level == "anonymous" ? "anonymous" : "restricted"
  json.topic story.topic
end
json.logo_path image_path("logocombo.svg")
json.user current_user
json.mapbox_access_token mapbox_token
json.mapbox_style mapbox_style
json.mapbox_3d @theme.mapbox_3d
json.use_local_map_server local_mapbox?
json.center_lat @theme.center_lat
json.center_long @theme.center_long
json.sw_boundary_lat @theme.sw_boundary_lat
json.sw_boundary_long @theme.sw_boundary_long
json.ne_boundary_lat @theme.ne_boundary_lat
json.ne_boundary_long @theme.ne_boundary_long
json.zoom @theme.zoom.to_f
json.pitch @theme.pitch.to_f
json.bearing @theme.bearing
json.marker_image_url image_url("place-marker.png")
json.marker_cluster_image_url image_url("place-marker-cluster.png")