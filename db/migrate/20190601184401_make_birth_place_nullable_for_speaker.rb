class MakeBirthPlaceNullableForSpeaker < ActiveRecord::Migration[5.2]
  def change
    change_column :speakers, :birthplace_id, :integer, null: true
  end
end
