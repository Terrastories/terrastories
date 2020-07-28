class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.string :background_img
      t.boolean :active

      t.timestamps
    end
  end
end
