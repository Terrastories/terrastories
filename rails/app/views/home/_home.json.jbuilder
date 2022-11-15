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
if current_user
  json.user do
    json.(current_user, :role, :display_name)
  end
end
json.logo_path image_path("logocombo.svg")

json.mapbox_access_token @community.theme.mapbox_token
json.mapbox_style @community.theme.mapbox_style
json.mapbox_3d @community.theme.mapbox_3d
json.map_projection @community.theme.map_projection
json.use_local_map_server @community.theme.offline_mode?
json.center_lat @community.theme.center_lat
json.center_long @community.theme.center_long
json.sw_boundary_lat @community.theme.sw_boundary_lat
json.sw_boundary_long @community.theme.sw_boundary_long
json.ne_boundary_lat @community.theme.ne_boundary_lat
json.ne_boundary_long @community.theme.ne_boundary_long
json.zoom @community.theme.zoom.to_f
json.pitch @community.theme.pitch.to_f
json.bearing @community.theme.bearing
json.marker_image_url image_url("place-marker.png")
json.marker_cluster_image_url image_url("place-marker-cluster.png")