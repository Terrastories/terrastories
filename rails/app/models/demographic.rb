class Demographic < ApplicationRecord
  has_and_belongs_to_many :user
  has_and_belongs_to_many :story
end
