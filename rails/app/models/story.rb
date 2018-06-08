class Story < ApplicationRecord
  has_many_attached :story_files
  belongs_to :point
  belongs_to :speaker
  acts_as_taggable

end
