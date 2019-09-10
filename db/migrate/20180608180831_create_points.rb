class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|
      t.string :title
      t.string :story
      t.decimal :lng
      t.decimal :lat
      t.string :location_type

      t.timestamps
    end
  end
end
