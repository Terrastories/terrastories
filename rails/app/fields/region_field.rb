require "administrate/field/base"

class RegionField < Administrate::Field::Base
  def to_s
    data
  end

  def candidates(community_id)
    Place.order(:region).where(community_id: community_id).distinct.pluck(:region)
  end
end
