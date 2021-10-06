require "administrate/field/base"

class TopicField < Administrate::Field::Base
  def to_s
    data
  end

  def candidates
    Story.order(:topic).distinct.pluck(:topic)
  end
end
