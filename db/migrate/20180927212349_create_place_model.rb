class CreatePlaceModel < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
