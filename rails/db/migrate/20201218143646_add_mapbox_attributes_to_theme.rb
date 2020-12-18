class AddMapboxAttributesToTheme < ActiveRecord::Migration[5.2]
  def change
    add_column :themes, :mapbox_style_url, :string
    add_column :themes, :mapbox_access_token, :string
  end
end
