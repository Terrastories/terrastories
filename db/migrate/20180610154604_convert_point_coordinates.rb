class ConvertPointCoordinates < ActiveRecord::Migration[5.2]
  def change
    change_column(:points, :lat, :decimal, precision: 15, scale: 13)
    change_column(:points, :lng, :decimal, precision: 15, scale: 13)
  end
end
