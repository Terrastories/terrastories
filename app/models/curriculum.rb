class Curriculum < ApplicationRecord
    belongs_to :user
    has_many :curriculum_stories
    has_many :stories, through: :curriculum_stories
    accepts_nested_attributes_for :curriculum_stories

    
end
