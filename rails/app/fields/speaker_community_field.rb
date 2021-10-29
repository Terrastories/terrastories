require "administrate/field/base"

class SpeakerCommunityField < Administrate::Field::Base
  def to_s
    data
  end

  def candidates(community_id)
    Speaker.order(:speaker_community).where(community_id: community_id).distinct.pluck(:speaker_community)
  end
end
