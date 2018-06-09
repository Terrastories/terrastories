class Story < ApplicationRecord
  # belongs_to :point
  belongs_to :speaker
  has_many_attached :story_files

  acts_as_taggable
end
