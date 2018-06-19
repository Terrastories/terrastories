class Speaker < ApplicationRecord
  has_many :stories
  has_one_attached :media
end
