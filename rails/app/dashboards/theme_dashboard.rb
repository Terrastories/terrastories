require "administrate/base_dashboard"

class ThemeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    background_img: Field::ActiveStorage.with_options({destroy_path: :admin_themes_path}),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    sponsor_logos: Field::ActiveStorage.with_options({destroy_path: :admin_themes_path}),
    mapbox_style_url: Field::String,
    mapbox_access_token: Field::String,
    center_lat: Field::Number,
    center_long: Field::Number,
    sw_boundary_lat: Field::Number,
    sw_boundary_long: Field::Number,
    ne_boundary_lat: Field::Number,
    ne_boundary_long: Field::Number,
    zoom: Field::Number,
    pitch: Field::Number,
    bearing: Field::Number
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  id
  background_img
  created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  background_img
  sponsor_logos
  mapbox_style_url
  mapbox_access_token
  center_lat
  center_long
  sw_boundary_lat
  sw_boundary_long
  ne_boundary_lat
  ne_boundary_long
  zoom
  pitch
  bearing
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  background_img
  sponsor_logos
  mapbox_style_url
  mapbox_access_token
  center_lat
  center_long
  sw_boundary_lat
  sw_boundary_long
  ne_boundary_lat
  ne_boundary_long
  zoom
  pitch
  bearing
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how themes are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(theme)
    I18n.t('helpers.label.theme.display_resource', community_name: theme.community.name)
  end

  def permitted_attributes
    super + [:sponsor_logos => []]
  end
end
