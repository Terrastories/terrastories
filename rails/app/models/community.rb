class Community < ApplicationRecord
  has_many :users
  has_many :places
  has_many :stories

  belongs_to :theme
end
