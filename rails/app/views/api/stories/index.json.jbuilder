json.total @stories.size
json.points @stories.flat_map { |s| s.public_points }.uniq
json.stories @stories do |story|
  json.extract! story, :id, :title, :topic, :desc, :language
  json.mediaContentTypes story.media_types

  json.createdAt story.created_at
  json.updatedAt story.updated_at
end
