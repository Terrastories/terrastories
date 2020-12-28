class SpeakerStory < ActiveRecord::Base
  belongs_to :speaker
  belongs_to :story
end

# == Schema Information
#
# Table name: speaker_stories
#
#  id         :bigint           not null, primary key
#  speaker_id :bigint           not null
#  story_id   :bigint           not null
#
