json.stories stories do |story|
  json.extract! story, :title, :desc, :id
  json.point do
    json.extract! story.point, :lng, :lat
  end
  json.media story.media do |media|
    json.url url_for(media)
    json.blob media.blob
  end
  json.speaker do |speaker|
    json.extract! story.speaker, :name, :picture_url
  end
end
