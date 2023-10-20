json.(@place, :id, :name, :description, :region)

json.placenameAudio @place.name_audio_url(full_url: true)
json.typeOfPlace @place.type_of_place

json.points [@place.public_point_feature]
