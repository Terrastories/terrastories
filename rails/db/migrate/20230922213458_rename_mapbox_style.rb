class RenameMapboxStyle < ActiveRecord::Migration[5.2]
  def change
    rename_column :themes, :mapbox_style_url, :map_style_url
  end
end
