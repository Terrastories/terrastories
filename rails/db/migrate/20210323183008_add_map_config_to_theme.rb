class AddMapConfigToTheme < ActiveRecord::Migration[5.2]
  def change
    add_column :themes, :center_lat, :decimal, :precision => 10, :scale => 6
    add_column :themes, :center_long, :decimal, :precision => 10, :scale => 6
    add_column :themes, :sw_boundary_lat, :decimal, :precision => 10, :scale => 6
    add_column :themes, :sw_boundary_long, :decimal, :precision => 10, :scale => 6
    add_column :themes, :ne_boundary_lat, :decimal, :precision => 10, :scale => 6
    add_column :themes, :ne_boundary_long, :decimal, :precision => 10, :scale => 6
    add_column :themes, :zoom, :decimal, :precision => 10, :scale => 6
    add_column :themes, :pitch, :decimal, :precision => 10, :scale => 6
    add_column :themes, :bearing, :decimal, :precision => 10, :scale => 6
  end
end
