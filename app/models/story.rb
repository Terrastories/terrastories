class Story < ApplicationRecord
  include Importable

  importer Importing::StoriesImporter

  has_many :speaker_stories
  has_many :speakers, through: :speaker_stories
  has_many_attached :media
  has_and_belongs_to_many :places
  belongs_to :interview_location, class_name: "Place", foreign_key: "interview_location_id", optional: true
  belongs_to :interviewer, class_name: "Speaker", foreign_key: "interviewer_id", optional: true

  enum permission_level: [:anonymous, :user_only, :editor_only]
end
