class CreateCurriculums < ActiveRecord::Migration[5.2]
  def change
    create_table :curriculums do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
