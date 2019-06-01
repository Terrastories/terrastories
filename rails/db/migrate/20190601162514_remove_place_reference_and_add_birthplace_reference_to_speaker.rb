class RemovePlaceReferenceAndAddBirthplaceReferenceToSpeaker < ActiveRecord::Migration[5.2]
  def change
    remove_reference :speakers, :place
    add_reference :speakers, :birthplace
  end
end
