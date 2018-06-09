class Story < ApplicationRecord
  has_many :medium
  belongs_to :point
  acts_as_taggable_on :categories
end
