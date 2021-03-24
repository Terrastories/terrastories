json.stories stories do |story|
  json.extract! story, :title, :desc, :id, :created_at
  json.points story.places.map(&:point_geojson)
  json.places story.places
  json.media story.media do |media|
    json.id media.id
    json.url url_for(media)
    json.blob media.blob
  end
  json.speakers story.speakers do |speaker|
    json.id speaker.id
    json.name speaker.name
    json.picture_url speaker.picture_url
  end

  json.media_links story.media_links do |media_link|
    json.id media_link.id
    json.url media_link.url
  end


  json.permission_level story.permission_level == "anonymous" ? "anonymous" : "restricted"
end
json.logo_path image_path("logocombo.svg")
json.user current_user
json.mapbox_access_token mapbox_token
json.mapbox_style mapbox_style
json.use_local_map_server local_mapbox?
json.center_lat center_lat
json.center_long center_long
json.marker_image_url image_url("marker1.png")
