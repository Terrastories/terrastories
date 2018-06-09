class AddSpeakerIdToStories < ActiveRecord::Migration[5.2]
  def change
    add_reference :stories, :speaker, foreign_key: true
    remove_column :stories, :speaker
  end
end
