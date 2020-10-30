class Community < ApplicationRecord
  has_many :users
  has_many :themes
  has_many :places
end
