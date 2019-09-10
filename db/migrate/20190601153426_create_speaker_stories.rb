class CreateSpeakerStories < ActiveRecord::Migration[5.2]
  def change
    create_join_table :speakers, :stories, table_name: :speaker_stories
  end
end