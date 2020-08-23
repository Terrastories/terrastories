class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.string :background_img
      t.boolean :active, null: false, default: false

      t.timestamps
    end
  end
end
