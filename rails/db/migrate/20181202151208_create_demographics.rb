class CreateDemographics < ActiveRecord::Migration[5.2]
  def change
    create_table :demographics do |t|
      t.string :name

      t.timestamps
    end
  end
end
