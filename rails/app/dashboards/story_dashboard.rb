require "administrate/base_dashboard"

class StoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    point: Field::BelongsTo,
    speaker: Field::BelongsTo,
    media_attachments: Field::HasMany.with_options(class_name: "ActiveStorage::Attachment"),
    media_blobs: Field::HasMany.with_options(class_name: "ActiveStorage::Blob"),
    taggings: Field::HasMany.with_options(class_name: "::ActsAsTaggableOn::Tagging"),
    base_tags: Field::HasMany.with_options(class_name: "::ActsAsTaggableOn::Tag"),
    tag_taggings: Field::HasMany.with_options(class_name: "ActsAsTaggableOn::Tagging"),
    tags: Field::HasMany.with_options(class_name: "ActsAsTaggableOn::Tag"),
    id: Field::Number,
    title: Field::String,
    desc: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :point,
    :speaker,
    :media_attachments,
    :media_blobs,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :point,
    :speaker,
    :media_attachments,
    :media_blobs,
    :taggings,
    :base_tags,
    :tag_taggings,
    :tags,
    :id,
    :title,
    :desc,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :point,
    :speaker,
    :media_attachments,
    :media_blobs,
    :taggings,
    :base_tags,
    :tag_taggings,
    :tags,
    :title,
    :desc,
  ].freeze

  # Overwrite this method to customize how stories are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(story)
  #   "Story ##{story.id}"
  # end
end
