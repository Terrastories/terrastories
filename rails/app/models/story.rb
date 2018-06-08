class Story < ApplicationRecord
  #has_many :medium
  has_many_attached :story_files
  #belongs_to :point
end
