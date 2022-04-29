class AddMapbox3dBoolean < ActiveRecord::Migration[5.2]
    def change
      add_column :themes, :mapbox_3d, :boolean, default: false
    end
  end