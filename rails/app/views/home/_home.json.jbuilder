json.stories stories do |story|
  json.extract! story, :title, :desc, :id
  json.point story.point.point_geojson
  json.place story.point.place
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
end
json.logo_path image_path("logocombo.svg")
json.user current_user
json.mapbox_access_token ENV["MAPBOX_ACCESS_TOKEN"]
json.mapbox_style ENV["MAPBOX_STYLE"] || "/tiles/styles/basic/style.json"
