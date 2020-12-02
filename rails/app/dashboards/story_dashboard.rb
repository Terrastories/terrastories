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
    language: Field::String,
    speakers: Field::HasMany,
    places: Field::HasMany,
    interview_location: Field::BelongsTo.with_options({class_name: "Place"}),
    interviewer: Field::BelongsTo.with_options({class_name: "Speaker"}),
    date_interviewed: Field::DateTime,
    media: Field::ActiveStorage.with_options({destroy_path: :admin_stories_path}),
    permission_level: EnumField,
    created_at: Field::DateTime,
    community: Field::BelongsTo,
    updated_at: Field::DateTime,
    media_links: Field::HasMany,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :title,
    :desc,
    :language,
    :speakers,
    :interview_location,
    :interviewer,
    :date_interviewed,
    :places,
    :permission_level,
    :media_links,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :title,
    :desc,
    :language,
    :speakers,
    :interview_location,
    :interviewer,
    :date_interviewed,
    :places,
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
    :language,
    :speakers,
    :interview_location,
    :interviewer,
    :date_interviewed,
    :places,
    :media,
    :permission_level,
    :media_links
  ].freeze

  # Overwrite this method to customize how stories are displayed
  # across all pages of the admin dashboard.

  def display_resource(story)
    story.title
  end

  def permitted_attributes
    super + [media: [], permission_level: [:anonymous, :user_only, :editor_only]]
  end
end
