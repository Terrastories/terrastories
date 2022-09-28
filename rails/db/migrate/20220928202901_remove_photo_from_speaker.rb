class RemovePhotoFromSpeaker < ActiveRecord::Migration[6.0]
  def change
    remove_column :speakers, :photo, :string
  end
end
