class Point < ApplicationRecord
  has_many :stories
  belongs_to :place
  acts_as_taggable
end
