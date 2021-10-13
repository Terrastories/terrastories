require "administrate/field/base"

class TypeOfPlaceField < Administrate::Field::Base
  def to_s
    data
  end

  def candidates(community_id)
    Place.order(:type_of_place).where(community_id: community_id).distinct.pluck(:type_of_place)
  end
end
