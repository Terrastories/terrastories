class Demographic < ApplicationRecord
  has_many :user
  has_many :story
end
