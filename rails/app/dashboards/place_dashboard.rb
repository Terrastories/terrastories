require "administrate/base_dashboard"

class PlaceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    description: Field::String,
    stories: Field::ScopedHasMany.with_options(scope: -> (field) { field.resource.community.stories }),
    long: Field::String.with_options(searchable: false),
    lat: Field::String.with_options(searchable: false),
    region: RegionField,
    photo: Field::ActiveStorage.with_options({destroy_path: :admin_places_path}),
    type_of_place: Field::String,
    community: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :photo,
    :name,
    :description,
    :region,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :description,
    :type_of_place,
    :region,
    :long,
    :lat,
    :stories,
    :photo,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :description,
    :type_of_place,
    :region,
    :long,
    :lat,
    :stories,
    :photo,
  ].freeze

  # Overwrite this method to customize how places are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(place)
    "#{place.name}"
  end
end
