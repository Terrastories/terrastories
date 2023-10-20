json.total @page.total

# Regardless of Story list page, all points in the data relation
# should be returned for map markers.
json.points @page.relation.flat_map { |s| s.public_points }.uniq

json.stories @stories do |story|
  json.extract! story, :id, :title, :topic, :desc, :language
  json.mediaContentTypes story.media_types
  json.mediaPreviewUrl story.media_preview_thumbnail

  json.createdAt story.created_at
  json.updatedAt story.updated_at
end

json.hasNextPage @page.has_next_page?
json.nextPageMeta @page.next_page_meta