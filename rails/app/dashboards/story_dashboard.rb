require "administrate/base_dashboard"

class StoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::String,
    desc: Field::Text,
    speaker: Field::BelongsTo,
    point: Field::BelongsTo,
    media: Field::ActiveStorage,
    permission_level: EnumField,
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
    :title,
    :desc,
    :speaker,
    :point,
    :media,
    :permission_level
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :title,
    :desc,
    :speaker,
    :point,
    :media,
    :permission_level,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :desc,
    :speaker,
    :point,
    :media,
    :permission_level
  ].freeze

  # Overwrite this method to customize how stories are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(story)
  #   "Story ##{story.id}"
  # end

  def permitted_attributes
    super + [media: [], permission_level: [:anonymous, :user_only, :editor_only]]
  end
end
