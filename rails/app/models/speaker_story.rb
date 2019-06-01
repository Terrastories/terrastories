class SpeakerStory < ActiveRecord::Base
  belongs_to :speaker
  belongs_to :story
end