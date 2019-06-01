class AddBirthPlaceAndYearToSpeaker < ActiveRecord::Migration[5.2]
  def change
    add_column :speakers, :birth_year, :datetime
    add_column :speakers, :birthplace_id, :integer
  end
end
