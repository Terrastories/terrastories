class Story < ApplicationRecord
  belongs_to :point
  belongs_to :speaker
  has_many_attached :media

  acts_as_taggable

  PERMISSION_LEVEL = ['anonymous', 'user', 'editor']
  validates_inclusion_of :permission_level, :in => PERMISSION_LEVEL
end
