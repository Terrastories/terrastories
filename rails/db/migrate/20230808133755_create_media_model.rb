class CreateMediaModel < ActiveRecord::Migration[6.1]
  def change
    create_table :media do |t|
      t.belongs_to :story

      t.timestamps
    end
  end
end
