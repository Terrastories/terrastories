class Story < ApplicationRecord
  has_many :medium
  belongs_to :point
end
