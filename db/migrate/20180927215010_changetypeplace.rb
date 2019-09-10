class Changetypeplace < ActiveRecord::Migration[5.2]
  def change
    rename_column :places, :type, :type_of_place
  end
end
