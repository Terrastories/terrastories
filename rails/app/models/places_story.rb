class PlacesStory < ActiveRecord::Base
    belongs_to :place
    belongs_to :story
  end