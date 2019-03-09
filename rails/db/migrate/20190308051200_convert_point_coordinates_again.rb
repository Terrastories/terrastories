class ConvertPointCoordinatesAgain < ActiveRecord::Migration[5.2]
  def change
    change_column(:points, :lat, :decimal, precision: 10, scale: 6)
    change_column(:points, :lng, :decimal, precision: 10, scale: 6)
  end
end
