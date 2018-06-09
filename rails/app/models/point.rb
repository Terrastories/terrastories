class Point < ApplicationRecord
  has_many :stories
  acts_as_taggable
end
