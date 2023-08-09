json.(@story, :id, :title, :desc, :topic, :language)
json.media @story.media do |media|
  json.contentType media.blob.content_type
  json.blob media.blob.id
  json.url rails_blob_url(media)
end
json.speakers @story.speakers do |speaker|
  json.(speaker, :id, :name)
  json.speakerCommunity speaker.speaker_community
  if speaker.photo.attached?
    if speaker.photo.variable?
      json.photoUrl rails_representation_url(speaker.photo.variant(resize_to_fit: [100, 100]))
    else
      json.photoUrl rails_blob_url(speaker.photo)
    end
  end
end
json.places @story.places do |place|
  json.(place, :id, :name, :description, :region)

  json.placenameAudio place.name_audio_url(full_url: true)
  json.photoUrl place.photo_url(full_url: true)
  json.typeOfPlace place.type_of_place
end

json.points @story.public_points
