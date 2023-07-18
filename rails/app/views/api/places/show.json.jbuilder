json.(@place, :id, :name, :description, :region)

json.placenameAudio @place.name_audio_url(full_url: true)
json.typeOfPlace @place.type_of_place

json.stories @place.stories.where(permission_level: :anonymous) do |story|
  json.extract! story, :id, :title, :topic, :desc, :language

  json.createdAt story.created_at
  json.updatedAt story.updated_at
end

json.points [@place.public_point_feature]
