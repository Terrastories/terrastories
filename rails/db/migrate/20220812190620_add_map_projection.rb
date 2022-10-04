class AddMapProjection < ActiveRecord::Migration[6.0]
    def change
      add_column :themes, :map_projection, :integer, default: 0
    end
  end