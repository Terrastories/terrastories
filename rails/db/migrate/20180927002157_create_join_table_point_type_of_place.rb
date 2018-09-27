class CreateJoinTablePointTypeOfPlace < ActiveRecord::Migration[5.2]
  def change
    create_join_table :points, :type_of_places do |t|
      # t.index [:point_id, :type_of_place_id]
      # t.index [:type_of_place_id, :point_id]
    end
  end
end
