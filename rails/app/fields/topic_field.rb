require "administrate/field/base"

class TopicField < Administrate::Field::Base
  def to_s
    data
  end

  def candidates(community_id)
    Story.order(:topic).where(community_id: community_id).distinct.pluck(:topic)
  end
end
