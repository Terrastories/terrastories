class AddCommunityToSpeaker < ActiveRecord::Migration[5.2]
  def change
    add_column :speakers, :community, :string
  end
end
