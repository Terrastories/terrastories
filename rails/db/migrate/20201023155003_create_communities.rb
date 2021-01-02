class CreateCommunities < ActiveRecord::Migration[5.2]
  def change
    create_table :communities do |t|
      t.string :name
      t.string :locale
      t.string :country

      t.timestamps
    end
  end
end
