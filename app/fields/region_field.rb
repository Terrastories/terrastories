require "administrate/field/base"

class RegionField < Administrate::Field::Base
  def to_s
    data
  end

  def candidates
    Place.order(:region).distinct.pluck(:region)
  end
end
