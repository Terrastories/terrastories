class Community < ApplicationRecord
  has_many :users
  has_many :themes
  has_many :places
  has_many :stories
end
