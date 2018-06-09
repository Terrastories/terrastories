class CreateMedia < ActiveRecord::Migration[5.2]
  def change
    create_table :media do |t|
      t.references :story, foreign_key: true
      t.string :media_type
      t.string :description
      t.string :name

      t.timestamps
    end
  end
end
