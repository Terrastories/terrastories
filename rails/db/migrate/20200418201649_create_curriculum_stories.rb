class CreateCurriculumStories < ActiveRecord::Migration[5.2]
  def change
    create_table :curriculum_stories do |t|
      t.references :curriculum, null: false, index: true, foreign_key: true
      t.references :story, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
