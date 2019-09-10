class RemoveSpeakerIdFromStories < ActiveRecord::Migration[5.2]
  def change
    Story.find_each do |story|
      SpeakerStory.create(speaker_id: story.speaker_id, story_id: story.id)
    end

    remove_column :stories, :speaker_id
  end
end
