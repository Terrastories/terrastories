require "administrate/base_dashboard"

class PointDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    stories: Field::HasMany,
    tags: Field::HasMany.with_options(class_name: "ActsAsTaggableOn::Tag"),
    id: Field::Number,
    title: Field::String,
    lng: Field::String.with_options(searchable: false),
    lat: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    place: Field::BelongsTo,
    region: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :title,
    :lng,
    :lat,
    :region,
    :place,
    :stories
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :title,
    :lng,
    :lat,
    :region,
    :place,
    :stories,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :stories,
    :title,
    :lng,
    :lat,
    :region,
  ].freeze

  # Overwrite this method to customize how points are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(point)
  #   "Point ##{point.id}"
  # end
end
