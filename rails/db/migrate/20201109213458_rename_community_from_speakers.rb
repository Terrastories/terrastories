class RenameCommunityFromSpeakers < ActiveRecord::Migration[5.2]
  def change
    rename_column :speakers, :community, :speaker_community
  end
end
