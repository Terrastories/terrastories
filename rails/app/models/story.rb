class Story < ApplicationRecord
  # belongs_to :point
  belongs_to :speaker
  has_many_attached :media

  acts_as_taggable

end
