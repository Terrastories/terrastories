require "administrate/base_dashboard"

class SpeakerDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    stories: Field::HasMany,
    media: Field::ActiveStorage,
    id: Field::Number,
    name: Field::String,
    photo: Field::String,
    region: Field::String,
    community: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :stories,
    :media,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :stories,
    :media,
    :id,
    :name,
    :photo,
    :region,
    :community,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :stories,
    :media,
    :name,
    :photo,
    :region,
    :community,
  ].freeze

  # Overwrite this method to customize how speakers are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(speaker)
  #   "Speaker ##{speaker.id}"
  # end
end
