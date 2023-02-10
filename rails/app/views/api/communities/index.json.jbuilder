json.array! @communities do |community|
  json.extract! community, :name, :description, :slug

  json.createdAt community.created_at
  json.updatedAt community.updated_at

  if community.display_image.attached?
    json.displayImage rails_blob_url(community.display_image)
  end
end
