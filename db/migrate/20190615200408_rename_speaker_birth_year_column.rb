class RenameSpeakerBirthYearColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :speakers, :birth_year, :birthdate
  end
end
