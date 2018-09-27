class Point < ApplicationRecord
  has_many :stories
  has_and_belongs_to_many :type_of_places
  acts_as_taggable
end
