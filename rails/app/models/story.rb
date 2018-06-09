class Story < ApplicationRecord
  has_many :medium
  belongs_to :point
  belongs_to :speaker
  acts_as_taggable
end
