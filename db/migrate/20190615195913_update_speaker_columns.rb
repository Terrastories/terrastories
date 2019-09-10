class UpdateSpeakerColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :speakers, :community
  end
end
