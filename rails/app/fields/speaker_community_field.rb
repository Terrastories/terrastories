require "administrate/field/base"

class SpeakerCommunityField < Administrate::Field::Base
  def to_s
    data
  end

  def candidates
    Speaker.order(:speaker_community).distinct.pluck(:speaker_community)
  end
end
