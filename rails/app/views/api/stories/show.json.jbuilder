envelope(json) do
json.(@story, :id, :title, :desc, :topic, :language)
json.media @story.media do |media|
  json.contentType media.content_type
  json.blob media.blob_id
  json.url rails_blob_url(media.media)
end
if @story.interviewer
  json.interviewer do
    json.(@story.interviewer, :name)
  end
end
if @story.interview_location
  json.interviewLocation do
    json.(@story.interview_location, :name)
  end
end
json.speakers @story.speakers do |speaker|
  json.(speaker, :id, :name)
  json.speakerCommunity speaker.speaker_community
  json.birthdate speaker.birthdate
  if speaker.photo.attached?
    if speaker.photo.variable?
      json.photoUrl rails_representation_url(speaker.photo.variant(resize_to_fit: [100, 100]))
    else
      json.photoUrl rails_blob_url(speaker.photo)
    end
  end
  if speaker.birthplace
    json.birthplace do
      json.(speaker.birthplace, :name)
    end
  end
end
json.places @story.places do |place|
  json.(place, :id, :name, :description, :region)

  json.placenameAudio place.name_audio_url(full_url: true)
  json.photoUrl place.photo_url(full_url: true)
  json.typeOfPlace place.type_of_place
  json.center RGeo::GeoJSON.encode(
    RGeo::GeoJSON::Feature.new(
      RGeo::Cartesian.factory.point(place.long, place.lat),
      place.id
    )
  )
end

json.points @story.public_points
end