require "administrate/field/base"

class LanguageField < Administrate::Field::Base
  def to_s
    data
  end

  def candidates(community_id)
    Story.order(:language).where(community_id: community_id).distinct.pluck(:language)
  end
end
