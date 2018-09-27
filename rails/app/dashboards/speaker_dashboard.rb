require "administrate/base_dashboard"

class SpeakerDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    media: Field::ActiveStorage,
    name: Field::String,
    region: Field::String,
    community: Field::String,
    stories: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :media,
    :name,
    :region,
    :community
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :media,
    :name,
    :region,
    :community,
    :stories,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :media,
    :name,
    :region,
    :community,
    :stories
  ].freeze

  # Overwrite this method to customize how speakers are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(speaker)
    "Speaker #{speaker.name}"
  end

  def permitted_attributes
    super + [media: [], permission_level: [:anonymous, :user_only, :editor_only]]
  end
end
