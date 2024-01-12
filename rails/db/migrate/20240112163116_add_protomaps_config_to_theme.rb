class AddProtomapsConfigToTheme < ActiveRecord::Migration[6.1]
  def change
    add_column :themes, :protomaps_api_key, :text
    add_column :themes, :protomaps_basemap_style, :text
  end
end
