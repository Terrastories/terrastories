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
    photo: Field::ActiveStorage,
    name: Field::String,
    stories: Field::ScopedHasMany.with_options(scope: -> (field) { field.resource.community.stories }),
    birthdate: Field::DateTime.with_options(format: "%d/%m/%Y"),
    birthplace: Field::ScopedBelongsTo.with_options(class_name: "Place", scope: -> (field) { field.resource.community.places }),
    community: Field::BelongsTo,
    speaker_community: Field::String,
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
    :birthdate,
    :speaker_community,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :photo,
    :name,
    :stories,
    :birthdate,
    :birthplace,
    :community,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :photo,
    :name,
    :stories,
    :birthdate,
    :birthplace,
    :speaker_community,
  ].freeze

  # Overwrite this method to customize how speakers are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(speaker)
    speaker.name
  end

  def permitted_attributes
    super + [photo: [], permission_level: [:anonymous, :user_only, :editor_only]]
  end
end
