class ConvertCoordinatesToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column(:places, :lat, :decimal, precision: 10, scale: 6)
    change_column(:places, :long, :decimal, precision: 10, scale: 6)
  end
end
