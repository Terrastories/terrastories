require "administrate/field/base"

class TypeOfPlaceField < Administrate::Field::Base
  def to_s
    data
  end

  def candidates
    Place.order(:type_of_place).distinct.pluck(:type_of_place)
  end
end
