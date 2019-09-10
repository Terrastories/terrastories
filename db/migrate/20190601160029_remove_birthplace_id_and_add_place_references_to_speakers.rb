class RemoveBirthplaceIdAndAddPlaceReferencesToSpeakers < ActiveRecord::Migration[5.2]
  def change
    remove_column :speakers, :birthplace_id
    add_reference :speakers, :place
  end
end
